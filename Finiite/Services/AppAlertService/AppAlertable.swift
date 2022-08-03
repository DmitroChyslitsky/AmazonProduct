
import Foundation

protocol AppAlertable {
    func showAlert(withTitle title: String, message: String,  completion: @escaping () -> Void)
    func showConfirm(withTitle title: String, message: String, titleOkButtonText: String, titleCancelButtonText: String,  completion: @escaping () -> Void)
    func showAlertPremium(withTitle title: String, message: String, titleOkButtonText: String, titleCancelButtonText: String,  completion: @escaping () -> Void)
}
