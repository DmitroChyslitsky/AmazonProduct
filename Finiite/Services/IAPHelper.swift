
import StoreKit
import SVProgressHUD
public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void

extension Notification.Name {
    static let IAPHelperPurchaseNotification = Notification.Name("IAPHelperPurchaseNotification")
}

open class IAPHelper: NSObject  {
    
    private let productIdentifiers: Set<ProductIdentifier>
    private var purchasedProductIdentifiers: Set<ProductIdentifier> = []
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    private var networkChecker: NetworkReachable? {
        return ServiceFacade.getService(NetworkReachable.self)
    }
    var products: [SKProduct] = []
    
    public init(productIds: Set<ProductIdentifier>) {
        productIdentifiers = productIds
        for productIdentifier in productIds {
            let purchased = UserDefaults.standard.bool(forKey: productIdentifier)
            if purchased {
                purchasedProductIdentifiers.insert(productIdentifier)
                print("Previously purchased: \(productIdentifier)")
            } else {
                print("Not purchased: \(productIdentifier)")
            }
        }
        super.init()
        if var network = self.networkChecker {
            network.onChanged = { isOnline in
                if isOnline {
                    if self.products.count == 0 {
                        self.requestInAppProducts()
                    }
                } else {
                    SVProgressHUD.dismiss()
                }
            }
        }
        SKPaymentQueue.default().add(self)
    }
    
}

// MARK: - StoreKit API

extension IAPHelper {
    
    public func requestProducts(_ completionHandler: @escaping ProductsRequestCompletionHandler) {
        guard let isOffline = self.networkChecker?.isOffline(), !isOffline else {
            SVProgressHUD.dismiss()
            return
        }
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest!.delegate = self
        productsRequest!.start()
    }
    
    public func buyProduct(_ product: SKProduct) {
        guard let isOffline = self.networkChecker?.isOffline(), !isOffline else {
            SVProgressHUD.dismiss()
            return
        }
        print("Buying \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
        return purchasedProductIdentifiers.contains(productIdentifier)
    }
    
    public func isHaveProductsPurchased() -> Bool {
        return purchasedProductIdentifiers.count > 0
    }
    
    public func removeProductsPurchase() {
        purchasedProductIdentifiers.removeAll()
        for productIdentifier in productIdentifiers {
            UserDefaults.standard.setValue(false, forKey: productIdentifier)
        }
    }
    
    public class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func restorePurchases() {
        guard let isOffline = self.networkChecker?.isOffline(), !isOffline else {
            SVProgressHUD.dismiss()
            return
        }
        SVProgressHUD.show()
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    public func requestInAppProducts() {
        guard let isOffline = self.networkChecker?.isOffline(), !isOffline else {
            return
        }
        SVProgressHUD.show()
        self.requestProducts{ [weak self] success, products in
            guard let self = self else { return }
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                if success {
                    self.products = products!
                }
            }
        }
    }
    
    public func getInAppProducts() -> [SKProduct] {
        if products.count == 0 {
            self.requestInAppProducts()
        }
        return products
    }
}

// MARK: - SKProductsRequestDelegate

extension IAPHelper: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Loaded list of products...",response.products)
        let products = response.products
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()
        
        for p in products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }
    
    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
}

// MARK: - SKPaymentTransactionObserver

extension IAPHelper: SKPaymentTransactionObserver {
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                print("Transaction: purchased")
                SVProgressHUD.dismiss()
                complete(transaction: transaction)
                break
            case .failed:
                print("Transaction: failed")
                SVProgressHUD.dismiss()
                fail(transaction: transaction)
                break
            case .restored:
                print("Transaction: restored")
                restore(transaction: transaction)
                break
            case .deferred:
                print("Transaction: deferred")
                SVProgressHUD.dismiss()
                break
            case .purchasing:
                print("Transaction: purchasing")
                SVProgressHUD.show()
                break
            default:
                break
            }
        }
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        SVProgressHUD.dismiss()
//        ServiceFacade.getService(AppAlertable.self)?.showAlert(withTitle: "Alert", message: "The restore purchase was unsuccessful", completion: {
//        })
    }
    
    public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        SVProgressHUD.dismiss()
//        ServiceFacade.getService(AppAlertable.self)?.showAlert(withTitle: "Alert", message: "The restore purchase was successful", completion: {
//        })
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("complete...")
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        
        print("restore... \(productIdentifier)")
        deliverPurchaseNotificationFor(identifier: productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    
    
    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        if let transactionError = transaction.error as NSError?,
            let localizedDescription = transaction.error?.localizedDescription,
            transactionError.code != SKError.paymentCancelled.rawValue {
            ServiceFacade.getService(AppAlertable.self)?.showAlert(withTitle: "Alert", message: localizedDescription, completion: {
            })
            print("Transaction Error: \(localizedDescription)")
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func deliverPurchaseNotificationFor(identifier: String?) {
        guard let identifier = identifier else { return }
        
        purchasedProductIdentifiers.insert(identifier)
        UserDefaults.standard.set(true, forKey: identifier)
        NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: identifier)
    }
}

public struct FiniiteProducts {
//    private static let productIdentifiers: Set<ProductIdentifier> = ["com.newsdc.musicup.camera"]
    private static let productIdentifiers: Set<ProductIdentifier> = ["com.finiite.app.product"]
    public static let store = IAPHelper(productIds: FiniiteProducts.productIdentifiers)
}


