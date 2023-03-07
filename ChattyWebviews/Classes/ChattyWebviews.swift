//
//  ChattyWebviews.swift
//  ChattyWebviews
//
//  Created by Teodor Dermendzhiev on 14.02.23.
//

import Foundation
import UIKit

public enum InstanceDescriptorDefaults {
    static let scheme = "cw"
    static let hostname = "localhost"
}

public class WebViewFactory {
    
    
    
    public static func createWebview(localFolder: String, path: String?) -> CWViewController {
        let vc = CWViewController()
        vc.configure(folderName: "www", path: path)
        return vc
    }
    

}
