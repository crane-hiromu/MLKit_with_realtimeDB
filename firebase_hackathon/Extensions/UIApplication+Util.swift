
import UIKit

extension UIApplication {
    
    // MARK: UIViewController topViewController
    
    var topViewController: UIViewController? {
        guard var topViewController = self.keyWindow?.rootViewController else { return nil }
        
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        return topViewController
    }
    
    func accessTopViewController(callback: @escaping (UIViewController) -> Void) {
        DispatchQueue.main.async { [weak self] () in
            guard var topViewController = self?.keyWindow?.rootViewController else { return }
            
            while let presentedViewController = topViewController.presentedViewController {
                topViewController = presentedViewController
            }
            self?.executeCallback(with: topViewController, and: callback)
        }
    }
    
    func present(to vc: UIViewController, animated: Bool = true, completion: @escaping () -> Void = { }) {
        DispatchQueue.main.async { [weak self] in
            self?.topViewController?.present(vc, animated: animated, completion: completion)
        }
    }
    
    private func executeCallback(with topVC: UIViewController?, and callback: @escaping (UIViewController) -> Void) {
        DispatchQueue.global().async {
            guard let top = topVC else { return }
            callback(top)
        }
    }
}
