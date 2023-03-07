import Foundation

public protocol Router {
    func route(for path: String) -> String
    var basePath: String { get set }
}

internal struct _Router: Router {
    var basePath: String = ""
    func route(for path: String) -> String {
        let pathUrl = URL(fileURLWithPath: path)

        // If there's no path extension it also means the path is empty or a SPA route
        if pathUrl.pathExtension.isEmpty {
            return basePath + "/index.html"
        }

        return basePath + path
    }
}
