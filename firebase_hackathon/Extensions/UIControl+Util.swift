
import UIKit

extension UIControl {
    
    func setEnable(_ isEnabled: Bool) {
        DispatchQueue.main.async {
            self.isEnabled = isEnabled
        }
    }
    
    func setSelected(_ isSelected: Bool) {
        DispatchQueue.main.async {
            self.isSelected = isSelected
        }
    }
}
