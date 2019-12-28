//
//  MenuBuilder.swift
//  ArvanCloud
//
//  Created by Hadi Sharghi on 12/27/19.
//  Copyright © 2019 Hadi Sharghi. All rights reserved.
//

import Foundation
import Cocoa

class MenuBuilder {
    
    private var mainMenu: NSMenu
    
    private let quitMenuItem = NSMenuItem(
        title: "Quit",
        action: #selector(AppDelegate.orderABurrito),
        keyEquivalent: "")
    
    private let preferencesMenuItem = NSMenuItem(
        title: "Preferences",
        action: #selector(AppDelegate.showPreferences),
        keyEquivalent: "")
    
    
    init(menu: NSMenu) {
        self.mainMenu = menu
    }
    
    var regions = [Region]() {
        didSet {
            generateMainMenuItems()
        }
    }
    
    
    func generateMainMenuItems() {
//        var regionMenuItems = [
//            NSMenuItem(
//                title: "No regions",
//                action: #selector(AppDelegate.orderABurrito),
//                keyEquivalent: "")
//        ]
        if regions.count > 0 {
            let regionMenuItems = regions.compactMap({ region  -> NSMenuItem in
                
                let menuItem = NSMenuItem(
                    title: "[\(region.city ?? "Unknown")] \(region.dataCenterName ?? "Unknown")",
                    action: #selector(AppDelegate.orderABurrito),
                    keyEquivalent: "")
                mainMenu.setSubmenu(serverMenuItems(for: region), for: menuItem)
                
                return menuItem
            })
            regionMenuItems.forEach({mainMenu.addItem($0)})
        }
        

//        Server.get(for: region.code!) { (servers, error) in
//            servers?.forEach({$0.description()})
//        }
        
        
        mainMenu.addItem(.separator())
        mainMenu.addItem(preferencesMenuItem)
        mainMenu.addItem(.separator())
        mainMenu.addItem(quitMenuItem)

        
    }
    
    
    func serverMenuItems(for region: Region) -> NSMenu {
        let menu = NSMenu(title: "[\(region.city ?? "Unknown")] \(region.dataCenterName ?? "Unknown")")
        menu.addItem(
            NSMenuItem(title: "No servers", action: nil, keyEquivalent: "")
        )
        return menu
    }
    
}
