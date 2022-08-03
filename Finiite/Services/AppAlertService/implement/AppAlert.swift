import Foundation
class AppAlert: AppAlertable {
    func showAlert(withTitle title: String, message: String,  completion: @escaping () -> Void) {
        ConfirmAlertView(titleText: title, messageText: message, titleOkButtonText: "OK", titleCancelButtonText: "", isAlert: true).show {
            completion()
        }
    }
    func showConfirm(withTitle title: String, message: String, titleOkButtonText: String, titleCancelButtonText: String,  completion: @escaping () -> Void) {
        ConfirmAlertView(titleText: title, messageText: message, titleOkButtonText: titleOkButtonText, titleCancelButtonText: titleCancelButtonText).show {
            completion()
        }
    }
    func showAlertPremium(withTitle title: String, message: String, titleOkButtonText: String, titleCancelButtonText: String,  completion: @escaping () -> Void) {
           ConfirmAlertView(titleText: title, messageText: message, titleOkButtonText: titleOkButtonText, titleCancelButtonText: titleCancelButtonText,isPremium: true).show {
               completion()
           }
       }
}
