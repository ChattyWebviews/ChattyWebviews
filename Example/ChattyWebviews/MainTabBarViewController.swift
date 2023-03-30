//
//  MainTabBarViewController.swift
//  ChattyWebviews_Example
//
//  Created by Teodor Dermendzhiev on 14.02.23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import ChattyWebviews

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (WebViewFactory.getModules().count == 0) {
            setupXPModules()
        }
        
        var module = WebViewFactory.getModules()[0]
        
        var scheduleVC: CWViewController!
        //let scheduleVC = WebViewFactory.createWebview(localFolder: "www", path: "/schedule")
        if let vc = WebViewFactory.createWebview(from: module, path: "/schedule") {
            
            scheduleVC = vc
        } else {
            //we are re-running from xcode - otherwise shouldnt reach it
            setupXPModules()
            module = WebViewFactory.getModules()[0]
            scheduleVC = WebViewFactory.createWebview(from: module, path: "/schedule")
            
        }
        scheduleVC.tabBarItem = UITabBarItem(title: "Schedule", image: nil, tag: 0)
        scheduleVC.messageDelegate = self
        
        let speakersVC = WebViewFactory.createWebview(localFolder: "testModule", path: "/speakers")
        speakersVC.tabBarItem = UITabBarItem(title: "Speakers", image: nil, tag: 1)
        speakersVC.messageDelegate = self
        
        let nativeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "button-sample")
        nativeVC.tabBarItem = UITabBarItem(title: "Native", image: nil, tag: 2)
        
        ModuleSynchronizer.shared.updateIfNeeded(module: module, email: "tester@test.com", appId: "demoapp") { success in
            print("Module \(module.name) updated! Please restart the app.")
        }
        
        self.viewControllers = [scheduleVC, speakersVC, nativeVC]
        
    }
    
    func setupXPModules() {
        let module = CWModule(name: "testModule", currentHash: "db8e07301", location: .Resources)
        WebViewFactory.initModules(modules: [module])
    }
    
}
 
extension MainTabBarViewController: CWMessageDelegate {
    
    func controller(_ controller: ChattyWebviews.CWViewController, didReceive message: ChattyWebviews.CWMessage) {
        print(message.topic)
        let msg = CWMessage(topic:"mife-a", body: ["msg":"done"])
        controller.sendMessage(msg)
    }

}
