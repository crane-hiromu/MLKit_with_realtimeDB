
import UIKit

extension UIColor {
    
    // MARK: Initialize
   
    convenience init(hex: Int, alpha: Double = 1.0) {
        
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
    
    convenience init?(rgbHexString: String, alpha: Double = 1.0) {
        let scanner = Scanner(string: rgbHexString.replacingOccurrences(of: "#", with: ""))
        var rgbHex: UInt32 = 0
        guard scanner.scanHexInt32(&rgbHex) else {
            return nil
        }
        
        self.init(hex: Int(rgbHex), alpha: alpha)
    }
}
