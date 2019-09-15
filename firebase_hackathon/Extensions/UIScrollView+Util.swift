
import UIKit

extension UIScrollView {
    
    func scrollToBottom(animated: Bool) {
        
        let bounds = self.bounds
        let boundsHeight = bounds.height
        var rect = CGRect()
        rect.origin.x = bounds.minX
        rect.origin.y = contentSize.height - boundsHeight
        rect.size.width = bounds.width
        rect.size.height = boundsHeight
        
        guard animated else {
            scrollRectToVisible(rect, animated: false)
            return
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
            self.scrollRectToVisible(rect, animated: false)
        })
    }
}
