
import Foundation
import UIKit

protocol ClassNameProtocol {
    
    static var className: String { get }
    var className: String { get }
}

extension ClassNameProtocol {
    
    static var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
}

extension NSObject: ClassNameProtocol {}

// MARK: - UIImpactFeedbackGenerator

@available(iOS 10.0, *)
extension NSObject {
    
    func feedback(of style: UIImpactFeedbackGenerator.FeedbackStyle) -> UIImpactFeedbackGenerator {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        return generator
    }
}
