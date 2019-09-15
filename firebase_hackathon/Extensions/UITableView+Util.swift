
import UIKit

extension UITableView {
    
    // MARK: UITableViewCell
    
    func registerFromNib<T: UITableViewCell>(type: T.Type) {
        
        let className = type.className
        let nib = UINib(nibName: className, bundle: Bundle(for: T.self))
        register(nib, forCellReuseIdentifier: className)
    }
    
    func register<T: UITableViewCell>(type: T.Type) {
        
        register(T.self, forCellReuseIdentifier: type.className)
    }

    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
    }
    
    // MARK: UITableHeaderFooterView
    
    func registerFromNib<T: UITableViewHeaderFooterView>(type: T.Type) {

        let className = type.className
        let nib = UINib(nibName: className, bundle: Bundle(for: T.self))
        register(nib, forHeaderFooterViewReuseIdentifier: className)
    }
    
    func register<T: UITableViewHeaderFooterView>(type: T.Type) {

        register(T.self, forHeaderFooterViewReuseIdentifier: type.className)
    }

    func dequeueHeaderFooterView<T: UITableViewHeaderFooterView>(with type: T.Type) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: T.className) as! T
    }

    func reload() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    func reloadWithShow() {
        DispatchQueue.main.async {
            self.reloadData()
            self.isHidden = false
        }
    }
    
    func reloadSections(section: Int, animation: UITableView.RowAnimation = .automatic) {
        DispatchQueue.main.async {
            /// beginUpdates・endUpdatesで囲わないと、iOS9でクラッシュする場合がある
            self.beginUpdates()
            self.reloadSections(IndexSet(integer: section), with: animation)
            self.endUpdates()
        }
    }
    
    func reloadSections(indexSet: IndexSet, animation: UITableView.RowAnimation = .automatic) {
        DispatchQueue.main.async {
            /// beginUpdates・endUpdatesで囲わないと、iOS9でクラッシュする場合がある
            self.beginUpdates()
            self.reloadSections(indexSet, with: animation)
            self.endUpdates()
        }
    }
    
    func reloadRows(indexPathes: [IndexPath], animate: UITableView.RowAnimation = .automatic) {
        DispatchQueue.main.async {
            /// beginUpdates・endUpdatesで囲わないと、iOS9でクラッシュする場合がある
            self.beginUpdates()
            self.reloadRows(at: indexPathes, with: animate)
            self.endUpdates()
        }
    }
    
    func insertSections(section: Int, animation: UITableView.RowAnimation = .automatic) {
        let integer = IndexSet(integer: section)
        
        DispatchQueue.main.async {
            /// beginUpdates・endUpdatesで囲わないと、iOS9でクラッシュする場合がある
            self.beginUpdates()
            self.insertSections(integer, with: animation)
            self.endUpdates()
        }
    }

    // CAUTION: main threadでしか使用しなてはならない
    // FIXME: main thread を意識しなくて済む作りにしたい
    func indexPathIsValid(indexPath: IndexPath) -> Bool {
        return indexPath.section < numberOfSections && indexPath.row < numberOfRows(inSection: indexPath.section)
    }
    
    func heightOfVisibleCell(_ indexPath: IndexPath) -> CGFloat {
        let cellRect = self.rectForRow(at: indexPath)
        let superview = self.superview
        let convertedRect = self.convert(cellRect, to: superview)
        let intersect = self.frame.intersection(convertedRect)
        return intersect.height
    }
}
