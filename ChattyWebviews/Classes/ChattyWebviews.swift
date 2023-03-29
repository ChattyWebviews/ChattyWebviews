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
        //let location = Bundle.main.resourceURL!.appendingPathComponent(module.name).appendingPathComponent("www")
        guard let location = module.appLocation else {
            print("No default package provided")
            return nil
        }
        let vc = CWViewController()
        vc.configure(appLocation: location, path: path)
        return vc
    }
    
    public static func saveModules(_ modules: [CWModule]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(modules) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "cw_modules")
        }
    }
    
    public static func getModules() -> [CWModule]? {
        if let savedModules = UserDefaults.standard.object(forKey: "cw_modules") as? Data {
            let decoder = JSONDecoder()
            if let loadedModules = try? decoder.decode(Array<CWModule>.self, from: savedModules) {
                return loadedModules
            }
        }
        return nil
    }
    
}
