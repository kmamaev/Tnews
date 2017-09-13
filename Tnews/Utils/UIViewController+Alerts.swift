import UIKit

extension UIViewController {
    func presentAlert(_ message: String, title: String?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel))
        present(alertVC, animated: true, completion: nil)
    }

    func presentErrorAlert(_ message: String) {
        presentAlert(message, title: NSLocalizedString("Error", comment: ""))
    }
}
