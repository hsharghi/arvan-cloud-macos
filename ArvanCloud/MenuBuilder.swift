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
        action: #selector(AppDelegate.orderABurrito),
        keyEquivalent: "")
    
    
    init(menu: NSMenu) {
        self.mainMenu = menu
    }
    
    var regions = [Region]() {
        didSet {
            generateMenuItems()
        }
    }
    
    
    func generateMenuItems() {
        var regionMenuItems = [
            NSMenuItem(
                title: "No regions",
                action: #selector(AppDelegate.orderABurrito),
                keyEquivalent: "")
        ]
        if regions.count > 0 {
            regionMenuItems = regions.compactMap({
                NSMenuItem(
                    title: "[\($0.city ?? "Unknown")] \($0.dataCenterName ?? "Unknown")",
                    action: #selector(AppDelegate.orderABurrito),
                    keyEquivalent: "")
            })
        }
        
        regionMenuItems.forEach({mainMenu.addItem($0)})
        mainMenu.addItem(.separator())
        mainMenu.addItem(preferencesMenuItem)
        mainMenu.addItem(.separator())
        mainMenu.addItem(quitMenuItem)

        
    }
    
    
    
}
