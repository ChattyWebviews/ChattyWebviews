//
//  InstanceConfiguration.swift
//  IonicNS
//
//  Created by Teodor Dermendzhiev on 28.09.22.
//

import UIKit

class InstanceConfiguration: NSObject {
    
    let _localURL: String
    let _serverURL: String
    let _appLocation: URL
    
    init(folderName: String) {
       
        
        _localURL = "\(InstanceDescriptorDefaults.scheme)://\(InstanceDescriptorDefaults.hostname)"
        _serverURL = _localURL
        
        
        _appLocation = Bundle.main.resourceURL!.appendingPathComponent(folderName)
        
        
        super.init()
    }

    
    init(appLocation: URL) {
        _localURL = "\(InstanceDescriptorDefaults.scheme)://\(InstanceDescriptorDefaults.hostname)"
        _serverURL = _localURL
        
        
        _appLocation = appLocation
        
        
        super.init()
    }
}
