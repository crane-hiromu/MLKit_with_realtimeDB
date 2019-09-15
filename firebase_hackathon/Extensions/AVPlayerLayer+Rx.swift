
import Foundation
import AVFoundation
import RxSwift
import RxCocoa

extension Reactive where Base: AVPlayerLayer {

    var readyForDisplay: Observable<Bool> {
        return self.observe(Bool.self, #keyPath(AVPlayerLayer.readyForDisplay))
            .map { $0 ?? false }
    }
}
