
// MARK: - String

extension Optional where Wrapped == String {
    
    var isEmpty: Bool {
        return self?.isEmpty ?? true
    }
}
