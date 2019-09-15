
import Foundation

extension Array {
    var isNotEmpty: Bool {
        return !self.isEmpty
    }

    func objectsAtIndexes(_ indexes: [Int]) -> [Element] {

        let elements: [Element] = indexes.map { (idx) in

            if idx < self.count {

                return self[idx]
            }

            return nil

            }.compactMap { $0 }

        return elements
    }

    func safeRange(_ range: Range<Int>) -> ArraySlice<Element> {

        return self.dropFirst(range.lowerBound).prefix(range.upperBound)
    }

    subscript (safe index: Int) -> Element? {

        get {

            return self.indices ~= index ? self[index] : nil
        }
        set {

            guard let value = newValue  else {
                return
            }

            if !(self.indices ~= index) {
                print("WARN: Array index out of range, so ignored. (array:\(self))")
                return
            }
            self[index] = value
        }
    }

    mutating func remove(at indexes: [Int]) {

        let newArray = self.enumerated().compactMap { indexes.contains($0.0) ? nil : $0.1 }
        self = newArray
    }

    mutating func insert(_ element: Element, safeAt index: Index) {
        guard 0 <= index && index <= count else {
            print("Index out of bounds while inserting item at index \(index) in \(self).")
            return
        }
        insert(element, at: index)
    }
    
    // ignore immutable
    mutating func forEach(body: (inout Element) throws -> Void) rethrows {
        for index in self.indices {
            try body(&self[index])
        }
    }
}
