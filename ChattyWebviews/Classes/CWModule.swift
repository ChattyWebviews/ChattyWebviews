//
//  CWModule.swift
//  ChattyWebviews
//
//  Created by Teodor Dermendzhiev on 22.03.23.
//

import Foundation

public class CWModules {
    
    static let shared = CWModules()
    
    private var modules: [CWModule] = []
    
    init() {
        self.modules = getSavedModules() ?? []
    }
    
    func initModules(modules: [CWModule]) {
        self.modules = modules
        save()
    }
    
    func update(module: CWModule) {
        let index = modules.firstIndex { m in
            m.name == module.name
        }
        guard let index = index else {
            print("Trying to update inexisting module")
            return
        }
        modules[index] = module
        save()
    }
    
    func save() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(modules) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "cw_modules")
        }
    }
    
    func getModules() -> [CWModule] {
        return self.modules
    }
    
    func getSavedModules() -> [CWModule]? {
        if let savedModules = UserDefaults.standard.object(forKey: "cw_modules") as? Data {
            let decoder = JSONDecoder()
            if let loadedModules = try? decoder.decode(Array<CWModule>.self, from: savedModules) {
                return loadedModules
            }
        }
        return nil
    }

}

public enum CWModuleLocation: String, Codable {
    case Documents
    case Resources
}

public class CWModule: Codable {
    public let name: String
    var appLocationURL: URL!
    public var location: CWModuleLocation
    public var currentHash: String?
    
    
    public init(name: String, currentHash: String?, location: CWModuleLocation = .Resources) {
        self.name = name
        self.currentHash = currentHash
        self.location = location
        setupLocation(location: location)
    }
    
    public func update(hash: String, location: CWModuleLocation = .Documents) {
        self.currentHash = hash
        setupLocation(location: location)
        CWModules.shared.update(module: self)
    }
    
    func setupLocation(location: CWModuleLocation) {
        if location == .Documents {
            appLocationURL = CWModulesParentDir.appendingPathComponent(name)
        } else {
            appLocationURL = Bundle.main.resourceURL!.appendingPathComponent(name)
        }
        self.location = location
    }
    
}
