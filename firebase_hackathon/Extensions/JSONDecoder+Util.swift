
// MARK: - JSONDecoder Extension

import Alamofire
import RxSwift

extension JSONDecoder {

    convenience init(type: JSONDecoder.KeyDecodingStrategy, format: JSONDecoder.DateDecodingStrategy) {
        self.init()
        self.keyDecodingStrategy = type
        self.dateDecodingStrategy = format
    }

    static let decoder: JSONDecoder = {
        return JSONDecoder(type: .convertFromSnakeCase, format: .iso8601)
    }()
}
