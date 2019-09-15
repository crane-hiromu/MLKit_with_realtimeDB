
import SafariServices

extension URL {
    
    var queryParams: [String: String] {
        var params = [String: String]()
        
        guard let comps = URLComponents(string: self.absoluteString), let queryItems = comps.queryItems else { return params }
        
        queryItems.forEach {
            params[$0.name] = $0.value
        }
        return params
    }
    
    func openURL() {
        guard UIApplication.shared.canOpenURL(self) else { return }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(self)
        } else {
            UIApplication.shared.openURL(self)
        }
    }
    
    func openSafari(from vc: UIViewController) {
        /// http, httpsがないものを safari View で開くとクラッシュする. ex 'www.google.com'など省略されているもの
        if self.absoluteString.contains("http://") || self.absoluteString.contains("https://") {
            vc.present(SFSafariViewController(url: self), animated: true)
        } else {
            openURL()
        }
    }
}
