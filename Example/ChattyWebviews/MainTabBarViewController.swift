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
        
        setupXPModules()
        
        let module = WebViewFactory.getModules()![0]
        
        //let scheduleVC = WebViewFactory.createWebview(localFolder: "www", path: "/schedule")
        guard let scheduleVC = WebViewFactory.createWebview(from: module, path: "/schedule") else {
            return
        }
        scheduleVC.tabBarItem = UITabBarItem(title: "Schedule", image: nil, tag: 0)
        scheduleVC.messageDelegate = self
        
        let speakersVC = WebViewFactory.createWebview(localFolder: "testModule", path: "/speakers")
        speakersVC.tabBarItem = UITabBarItem(title: "Speakers", image: nil, tag: 1)
        speakersVC.messageDelegate = self
        
        let nativeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "button-sample")
        nativeVC.tabBarItem = UITabBarItem(title: "Native", image: nil, tag: 2)
        
        ModuleSynchronizer.shared.updateIfNeeded(module: module, email: "tester@test.com", appId: "demoapp")
        
        self.viewControllers = [scheduleVC, speakersVC, nativeVC]
        
    }
    
    func setupXPModules() {
        let module = CWModule(name: "testModule", currentHash: "db8e07301")
        WebViewFactory.saveModules([module])
    }
    
}
 
extension MainTabBarViewController: CWMessageDelegate {
    
    func controller(_ controller: ChattyWebviews.CWViewController, didReceive message: ChattyWebviews.CWMessage) {
        print(message.topic)
        let msg = CWMessage(topic:"mife-a", body: ["msg":"done"])
        controller.sendMessage(msg)
    }

}
