//
//  ChattyWebviews.swift
//  ChattyWebviews
//
//  Created by Teodor Dermendzhiev on 14.02.23.
//

import Foundation
import UIKit

public let CWModulesParentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

public enum InstanceDescriptorDefaults {
    static let scheme = "cw"
    static let hostname = "localhost"
}

public class WebViewFactory {
    
    public static func createWebview(localFolder: String, path: String?) -> CWViewController {
        let vc = CWViewController()
        vc.configure(folderName: localFolder, path: path)
        return vc
    }
    
    public static func createWebview(from module: CWModule, path: String?) -> CWViewController? {
        
        //TODO: if the module doesnt have defaultLocation (that is - is not in the resource dir)
        //we will have to download it first so the webview will show a loading image
        guard FileManager.default.fileExists(atPath: module.appLocationURL.path) else {
            print("WARNING: No default package provided. When re-running from Xcode fetched packages are deleted.")
            return nil
        }
        let vc = CWViewController()
        vc.configure(appLocation: module.appLocationURL, path: path)
        return vc
    }
    
    public static func getModules() -> [CWModule] {
        return CWModules.shared.getModules()
    }
    
    public static func initModules(modules: [CWModule]) {
        CWModules.shared.initModules(modules: modules)
    }
    
}
