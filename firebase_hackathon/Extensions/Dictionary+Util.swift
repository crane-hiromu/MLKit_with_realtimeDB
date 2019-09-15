
import Foundation

extension Dictionary {

    // https://stackoverflow.com/q/40152483
    func valueFromLowercasedDictionary(key: String) -> Any? {

        let keyValues = self.map { (String(describing: $0.key).lowercased(), String(describing: $0.value)) }
        return keyValues.first(where: { $0.0 == key.lowercased() })?.1
    }
}
