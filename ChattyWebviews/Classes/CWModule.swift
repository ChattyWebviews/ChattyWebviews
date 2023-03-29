//
//  CWModule.swift
//  ChattyWebviews
//
//  Created by Teodor Dermendzhiev on 22.03.23.
//

import Foundation

public class CWModule: Codable {
    public let name: String
    public var appLocation: URL?
    public var currentHash: String? {
        didSet {
            setAppLocation()
        }
      }
    
    
    public init(name: String, currentHash: String?) {
        self.name = name
        self.currentHash = currentHash
        setAppLocation()
    }
    
    func setAppLocation() {
        let parentFolder = CWModulesParentDir
        let newModuleFolder = parentFolder.appendingPathComponent(name)
        let defaultModuleFolder = Bundle.main.resourceURL!.appendingPathComponent(name)
        if FileManager.default.fileExists(atPath: newModuleFolder.path) {
            appLocation = newModuleFolder
        } else if FileManager.default.fileExists(atPath: defaultModuleFolder.path)  {
            appLocation = defaultModuleFolder
        } else {
            appLocation = nil
        }
    }
}
