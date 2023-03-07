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
        
        let scheduleVC = WebViewFactory.createWebview(localFolder: "www", path: "/schedule")
        scheduleVC.tabBarItem = UITabBarItem(title: "Schedule", image: nil, tag: 0)
        scheduleVC.messageDelegate = self
        
        let speakersVC = WebViewFactory.createWebview(localFolder: "www", path: "/speakers")
        speakersVC.tabBarItem = UITabBarItem(title: "Speakers", image: nil, tag: 1)
        speakersVC.messageDelegate = self
        
        let nativeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "button-sample")
        nativeVC.tabBarItem = UITabBarItem(title: "Native", image: nil, tag: 2)
        
        self.viewControllers = [scheduleVC, speakersVC, nativeVC]
        
    }
    
}
 
extension MainTabBarViewController: CWMessageDelegate {
    
    func controller(_ controller: ChattyWebviews.CWViewController, didReceive message: ChattyWebviews.CWMessage) {
        print(message.topic)
        let msg = CWMessage(topic:"mife-a", body: ["msg":"done"])
        controller.sendMessage(msg)
    }

}
