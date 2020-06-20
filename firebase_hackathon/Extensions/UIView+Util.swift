
import UIKit

// MARK: - UIView
extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable var leftBorderWidth: CGFloat {
        get {
            return 0.0   // Just to satisfy property
        }
        set {
            let line = UIView(frame: CGRect(x: 0.0, y: 0.0, width: newValue, height: bounds.height))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = UIColor(cgColor: layer.borderColor!)
            self.addSubview(line)

            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line(==lineWidth)]", options: [], metrics: metrics, views: views))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line]|", options: [], metrics: nil, views: views))
        }
    }

    @IBInspectable var topBorderWidth: CGFloat {
        get {
            return 0.0   // Just to satisfy property
        }
        set {
            let line = UIView(frame: CGRect(x: 0.0, y: 0.0, width: bounds.width, height: newValue))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = borderColor
            self.addSubview(line)

            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line]|", options: [], metrics: nil, views: views))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line(==lineWidth)]", options: [], metrics: metrics, views: views))
        }
    }

    @IBInspectable var rightBorderWidth: CGFloat {
        get {
            return 0.0   // Just to satisfy property
        }
        set {
            let line = UIView(frame: CGRect(x: bounds.width, y: 0.0, width: newValue, height: bounds.height))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = borderColor
            self.addSubview(line)

            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "[line(==lineWidth)]|", options: [], metrics: metrics, views: views))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line]|", options: [], metrics: nil, views: views))
        }
    }
    @IBInspectable var bottomBorderWidth: CGFloat {
        get {
            return 0.0   // Just to satisfy property
        }
        set {
            let line = UIView(frame: CGRect(x: 0.0, y: bounds.height, width: bounds.width, height: newValue))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = borderColor
            self.addSubview(line)

            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line]|", options: [], metrics: nil, views: views))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[line(==lineWidth)]|", options: [], metrics: metrics, views: views))
        }
    }

    func makeCornerRound(radius: CGFloat, corners: UIRectCorner) {

        self.cornerRadius = 0

        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }

    enum drawType {

        case lowerTriangle
    }
    
    func draw(type: drawType, context: CGContext?, rect: CGRect, color: UIColor, radius: CGFloat = 8.0) {

        guard let ctx = context else {
            return
        }

        switch type {

        case .lowerTriangle:
            ctx.saveGState()

            ctx.move(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
            ctx.addLine(to: CGPoint(x: rect.origin.x + (rect.size.width / 2), y: rect.origin.y + rect.size.height))
            ctx.addLine(to: CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y))
            ctx.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y))

            ctx.setFillColor(color.cgColor)
            ctx.fillPath()

            ctx.restoreGState()
        }
    }
    
    /// 破線のボーダー
    func drawDashedLine(_ color: UIColor,
                        _ lineWidth: CGFloat,
                        _ lineSize: NSNumber,
                        _ spaceSize: NSNumber,
                        _ type: DashedLineType = .all) {
        
        let dashedLineLayer = CAShapeLayer()
        dashedLineLayer.frame = bounds
        dashedLineLayer.strokeColor = color.cgColor
        dashedLineLayer.lineWidth = lineWidth
        dashedLineLayer.lineDashPattern = [lineSize, spaceSize]
        let path: CGMutablePath = CGMutablePath()
        
        switch type {
        case .all:
            dashedLineLayer.fillColor = nil
            dashedLineLayer.path = UIBezierPath(rect: dashedLineLayer.frame).cgPath
            
        case .top:
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: frame.size.width, y: 0))
            dashedLineLayer.path = path
            
        case .bottom:
            path.move(to: CGPoint(x: 0, y: frame.size.height))
            path.addLine(to: CGPoint(x: frame.size.width, y: frame.size.height))
            dashedLineLayer.path = path
            
        case .right:
            path.move(to: CGPoint(x: frame.size.width, y: 0))
            path.addLine(to: CGPoint(x: frame.size.width, y: frame.size.height))
            dashedLineLayer.path = path
            
        case .left:
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: frame.size.height))
            dashedLineLayer.path = path
        }

        layer.addSublayer(dashedLineLayer)
    }
    
    enum DashedLineType {
        case all, top, bottom, right, left
    }
    
    static func instantiate<T: UIView>() -> T {
        return UINib(nibName: className, bundle: nil)
            .instantiate(withOwner: self, options: nil)
            .first as! T
    }
    
    /// 親に合わせる
    func equalToParentConstraint(
        for target: UIView,
        top: CGFloat = 0,
        left: CGFloat = 0,
        bottom: CGFloat = 0,
        right: CGFloat = 0
    ) {
        addSubview(target)
        target.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            target.topAnchor.constraint(equalTo: topAnchor, constant: top),
            target.leftAnchor.constraint(equalTo: leftAnchor, constant: left),
            target.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottom),
            target.rightAnchor.constraint(equalTo: rightAnchor, constant: right)
        ])
    }
    
    func equalToConstraint(for target: UIView, with constraints: [NSLayoutConstraint]) {
        addSubview(target)
        target.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - Animations

extension UIView {
    
    // MARK: Enums
    
    enum ViewAnimationType: String {
        case fadeIn, fadeOut, drawBorderWidth
        
        var key: String {
            return "ViewAnimationType.\(self.rawValue)"
        }
    }
    
    // MARK: Common
    
    func addAnimation(by type: ViewAnimationType, with animation: CAAnimation) {
        layer.add(animation, forKey: type.key)
    }

    func removeAnimation(by type: ViewAnimationType) {
        layer.removeAnimation(forKey: type.key)
    }
    
    // MARK: opacity

    func fadeIn(withDuration duration: TimeInterval, completion: (() -> Void)? = nil) {
        self.toggle(isFadeIn: true, duration: duration, completion: completion)
    }

    func fadeOut(withDuration duration: TimeInterval, completion: (() -> Void)? = nil) {
        self.toggle(isFadeIn: false, duration: duration, completion: completion)
    }

    private func toggle(isFadeIn: Bool, duration: TimeInterval, completion: (() -> Void)? = nil) {
        removeAnimation(by: .fadeIn)
        removeAnimation(by: .fadeOut)
        
        isHidden = !isFadeIn
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: .opacity)
        animation.fromValue = isFadeIn ? 0.0 : 1.0
        animation.toValue = isFadeIn ? 1.0 : 0.0
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        addAnimation(by: (isFadeIn ? .fadeIn : .fadeOut), with: animation)
        CATransaction.setCompletionBlock(completion)
        CATransaction.commit()
    }
    
    // MARK: borderWidth
    
    func drawBorderWidth(duration: TimeInterval, delay: TimeInterval = 0.0, width: CGFloat) {

        let animation = CABasicAnimation(keyPath: .borderWidth)
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.beginTime = CACurrentMediaTime() + delay
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = width
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        addAnimation(by: .drawBorderWidth, with: animation)
    }
    
    func eraseBorderWidth() {
        borderWidth = 0
        removeAnimation(by: .drawBorderWidth)
    }
    
    // MARK: transform
    
    func addTransform(affine: CGAffineTransform = CGAffineTransform(scaleX: 1.0, y: 1.0),
                      duration: TimeInterval,
                      delay: TimeInterval = 0,
                      damping: CGFloat = 0.5,
                      velocity: CGFloat = 0.1) {
        
        transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: duration,
                       delay: delay,
                       usingSpringWithDamping: damping,
                       initialSpringVelocity: velocity,
                       options: .curveEaseIn,
                       animations: {
                        
            self.transform = affine
        })
    }
    
    func removeTransform() {
        layer.removeAllAnimations()
        transform = .identity
    }
}

extension CABasicAnimation {
    
    enum KeyPathType: String {
        case opacity, borderWidth
    }
    
    convenience init(keyPath: KeyPathType) {
        self.init(keyPath: keyPath.rawValue)
    }
}
