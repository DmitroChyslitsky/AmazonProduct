
import UIKit
import SwifterSwift
class ConfirmAlertView: UIView {
    // MARK: Properties
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var ctrHeightViewButton: NSLayoutConstraint!
    @IBOutlet weak var viewButtonCancel: UIView!
    @IBOutlet weak var viewPremium: UIView!
    @IBOutlet weak var btnBuyPremium: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    
    
    fileprivate var clickOKButtonBlock: (() -> Void)?
    private var isShowing = false
    var messageText: String
    var titleText: String
    var titleOkButtonText: String
    var titleCancelButtonText: String
    var isAlert = false // == true if just want use OK button.
    var isPremium = false
    
    // MARK: Init
    required init?(coder aDecoder: NSCoder) {
        self.messageText = ""
        self.titleText = ""
        self.titleOkButtonText = ""
        self.titleCancelButtonText = ""
        super.init(coder: aDecoder)
    }
    
    init(titleText: String,
         messageText: String,
         titleOkButtonText: String,
         titleCancelButtonText: String,
         isAlert: Bool = false,
         isPremium: Bool = false) {
        self.messageText = messageText
        self.titleText = titleText.uppercased()
        self.titleOkButtonText = titleOkButtonText
        self.titleCancelButtonText = titleCancelButtonText
        self.isAlert = isAlert
        self.isPremium = isPremium
        super.init(frame: .zero)
        self.setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.fillToSuperview()
    }
    
    fileprivate func setup() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.purchaseNotification(notification:)), name: Notification.Name.IAPHelperPurchaseNotification, object: nil)

        
        self.initFromNIB()
        
        self.contentView.fillToSuperview()
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.contentView.backgroundColor = UIColor.white.withAlphaComponent(0.0)
                
        self.titleLabel.text = self.titleText
        self.messageLabel.text = self.messageText
        self.okButton.setTitle(self.titleOkButtonText, for: .normal)
        self.cancelButton.setTitle(self.titleCancelButtonText,for: .normal)
        if self.isAlert {
            self.viewButtonCancel.isHidden = true
            self.cancelButton.isHidden = true
            self.ctrHeightViewButton.constant = 65
            self.okButton.addTarget(self, action: #selector(cancelButtonPressed(_:)), for: .touchUpInside)
        } else {
            self.okButton.addTarget(self, action: #selector(okButtonPressed(_:)), for: .touchUpInside)
            self.cancelButton.addTarget(self, action: #selector(cancelButtonPressed(_:)), for: .touchUpInside)
        }
        if isPremium {
            self.viewPremium.isHidden = false
            self.btnSkip.addTarget(self, action: #selector(cancelButtonPressed(_:)), for: .touchUpInside)
            self.btnBuyPremium.addTarget(self, action: #selector(purchaseButtonPressed(_:)), for: .touchUpInside)
        } else {
            self.viewPremium.isHidden = true
        }
    }
    
    fileprivate func initFromNIB() {
        Bundle.main.loadNibNamed(String(describing: ConfirmAlertView.self), owner: self, options: nil)
        self.addSubview(self.contentView)
        self.backgroundColor = UIColor.white.withAlphaComponent(0)
    }
    
    public func show(completion: @escaping () -> Void) {
        if !isShowing {
            guard let topWindow = UIApplication.shared.windows.first else { return }
            for view in topWindow.subviews {
                if view is ConfirmAlertView {
                    view.removeFromSuperview()
                }
            }
            topWindow.addSubview(self)
            
            self.alpha = 0.0
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                guard let `self` = self else { return }
                self.alpha = 1.0
            })
            
            self.clickOKButtonBlock = completion
            self.isShowing = true
        }
        
    }
    
    fileprivate func dismiss() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let `self` = self else { return }
            self.alpha = 0.0
        }) { (completed) -> Void in
            self.removeFromSuperview()
            self.isShowing = false
        }
    }

    @IBAction func clickRestore(_ sender: Any) {
        FiniiteProducts.store.restorePurchases()
    }
}

// MARK: - Handle events
extension ConfirmAlertView {
    @objc fileprivate func okButtonPressed(_ sender: UIButton) {
        self.clickOKButtonBlock?()
        self.dismiss()
    }
    
    @objc fileprivate func purchaseButtonPressed(_ sender: UIButton) {
        self.clickOKButtonBlock?()
//        self.dismiss()
    }
    @objc func purchaseNotification(notification: Notification) {
        if let productIdentifier = notification.object as? String,
           FiniiteProducts.store.isProductPurchased(productIdentifier) {
            print("isProductPurchased",productIdentifier)
            self.dismiss()
        }
    }
    
    @objc fileprivate func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss()
    }
}
