//
//  ModuleSynchronizer.swift
//  ChattyWebviews
//
//  Created by Teodor Dermendzhiev on 16.03.23.
//

import Foundation
import SSZipArchive

public class ModuleSynchronizer: HTTPRequestHandler, Executor {
    typealias UpdateCheckResult = Result<UpdateCheckResponse, Error>
    
    let httpClient: HTTPClientProtocol
    internal let executionQueue: DispatchQueue
    
    public static let shared = ModuleSynchronizer()
    
    init() {
        httpClient = URLSessionHTTPClient()
        self.executionQueue = DispatchQueue.main
    }
    
    public func updateIfNeeded(module: CWModule, email: String, appId: String) {
        self.checkForUpdate(email: email, appId: appId, moduleName: module.name, hash: module.currentHash) { modulePath, hash in
            if let modulePath = modulePath, let hash = hash {
                
                DispatchQueue.global(qos: .userInitiated).async {
                    self.downloadPackage(url: modulePath) { zipUrl in
                        
                        if let zipUrl = zipUrl {
                            
                            self.unzipPackage(for: module, zipUrl: zipUrl) { success in
                                if (success) {
                                    module.currentHash = hash
                                    self.updateModuleLocation(module: module)
                                    //TODO: save module changes (in local storage)
                                    if #available(iOS 16.0, *) {
                                        self.deleteZipArchive(url: URL(filePath: zipUrl.absoluteString))
                                    } else {
                                        self.deleteZipArchive(url: URL(fileURLWithPath: zipUrl.absoluteString))
                                    }
                                    
                                    
                                }
                            }
                        }
                        
                    }
                }
                
                
            }
        }
    }
    
     func checkForUpdate(email: String, appId: String, moduleName: String, hash: String?,  completion: @escaping (String?, String?) -> Void) {
        let reqData = UpdateCheckRequest(email: email, appId: appId, moduleName: moduleName, currentMd5: hash)
        httpClient.post(URL(string: "https://europe-west1-appwraps-releases.cloudfunctions.net/checkForUpdate")!, body: reqData) { result in
            self.execute {
                
                self.handleResponse(of: UpdateCheckResponse.self, result: result) { updateResult in
                    switch updateResult {
                    case .success(let data):
                        if data.hasUpdate {
                            completion(data.update.modulePath, data.update.md5)
                            return
                        }
                        break
                    case .failure(let error):
                        //todo: handle
                        break
                    }
                    completion(nil, nil)
                }
            }
            print(result)
        }
    }
    
    func unzipPackage(for module: CWModule, zipUrl: URL, completion: @escaping (Bool) -> Void) {
        //this is the current module folder
        let parentFolder = CWModulesParentDir
        
        //this is because we dont have such folder initially
        createModuleFolderInDocsIfNeeded(module: module)
        
        let newModuleFolder = parentFolder.appendingPathComponent("\(module.name)-update")
        if !FileManager.default.fileExists(atPath: newModuleFolder.path) {
            do {
                try FileManager.default.createDirectory(atPath: newModuleFolder.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        SSZipArchive.unzipFile(atPath: zipUrl.absoluteString, toDestination: newModuleFolder.path) { entry, zipInfo, entryNumber, totalProgress in
            //progress
        } completionHandler: { path, success, error in
            completion(success)
        }
    }
    
    func downloadPackage(url: String, completion: @escaping (URL?) -> Void) {
        FileDownloader.loadFileSync(url: URL(string: url)!) { path, error in
            completion(URL(string: path ?? "")) //todo clean
        }
    }
    
    func deleteZipArchive(url: URL) {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: url)
        } catch {
            print("Failed to delete zip archive")
        }
    }
    
    func updateModuleLocation(module: CWModule) {
        let fileManager = FileManager.default
        
        let newUrl = CWModulesParentDir.appendingPathComponent("\(module.name)-update")
        do {
            guard let location = module.appLocation else { return }
            try fileManager.removeItem(at: location)//handle errors and add some checks
            try fileManager.moveItem(at: newUrl, to: location)
        } catch {
            print("Failed to delete zip archive")
        }
        
    }
    
    func createModuleFolderInDocsIfNeeded(module: CWModule) {
        let currModuleFolder = CWModulesParentDir.appendingPathComponent(module.name)
        if !FileManager.default.fileExists(atPath: currModuleFolder.path) {
            do {
                try FileManager.default.createDirectory(atPath: currModuleFolder.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
