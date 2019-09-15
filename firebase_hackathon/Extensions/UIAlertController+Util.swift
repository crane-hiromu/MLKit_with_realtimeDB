
import UIKit

extension UIAlertController {

    func addAction(
        title: String,
        style: UIAlertAction.Style = .default,
        handler: ((UIAlertAction) -> Void)? = nil
    ) -> Self {

        addAction(UIAlertAction(
            title: title,
            style: style,
            handler: handler
        ))

        return self
    }

    func show(with duration: Double? = nil) {
        DispatchQueue.main.async {
            guard !(UIApplication.shared.topViewController is UIAlertController) else { return }

            UIApplication.shared.topViewController?.present(self, animated: true) { [weak self] () in
                guard let duration = duration else { return }
                self?.dismiss(after: duration)
            }
        }
    }

    func dismiss(after duration: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.dismiss(animated: true)
        }
    }
}
