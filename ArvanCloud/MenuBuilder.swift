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
    
    var regions = [Region]()
    
    
    func updateMenu() {
        mainMenu.removeAllItems()
        generateMainMenuItems()
    }
    
    func generateMainMenuItems() {

        regionMenuIems().forEach({mainMenu.addItem($0)})
        
        mainMenu.addItem(.separator())
        mainMenu.addItem(preferencesMenuItem)
        mainMenu.addItem(.separator())
        mainMenu.addItem(quitMenuItem)
        
    }
    
    func regionMenuIems() -> [NSMenuItem] {
        
        guard regions.count > 0 else {
            return []
        }
        
        let regionMenuItems = regions.compactMap({ region  -> NSMenuItem in
            
            let menuItem = NSMenuItem(
                title: "[\(region.city ?? "Unknown")] \(region.dataCenterName ?? "Unknown")",
                action: #selector(AppDelegate.orderABurrito),
                keyEquivalent: "")
            
            mainMenu.setSubmenu(serversMenuItems(for: region), for: menuItem)
            
            return menuItem
        })
        
        return regionMenuItems
    }
    
    
    
    func serversMenuItems(for region: Region) -> NSMenu {
        
        let menu = NSMenu(title: "[\(region.city ?? "Unknown")] \(region.dataCenterName ?? "Unknown")")
        
        let addServerItem = NSMenuItem(title: "Add server", action: #selector(AppDelegate.addServer), keyEquivalent: "")
        addServerItem.image = NSImage(named: "add")
        menu.addItem(addServerItem)
        menu.addItem(.separator())
        
        guard region.servers?.count ?? 0 > 0 else {
                menu.addItem(
                NSMenuItem(title: "No servers", action: nil, keyEquivalent: "")
            )
            return menu
        }


        for server in region.servers ?? [] {
            let serverMenuItem = NSMenuItem(title: "\(server.name ?? "Unknown") [\(server.ip ?? "Unknown IP")]" , action: nil, keyEquivalent: "")
            mainMenu.setSubmenu(serverActionMenu(for: server), for: serverMenuItem)
//            [
//                NSMenuItem(title: "Start", action: nil, keyEquivalent: ""),
//                NSMenuItem(title: "Stop", action: nil, keyEquivalent: ""),
//                NSMenuItem(title: "Restart", action: nil, keyEquivalent: ""),
//                NSMenuItem(title: "Delete", action: nil, keyEquivalent: ""),
//            ].forEach({menu.addItem($0)})
            
            menu.addItem(serverMenuItem)

        }
        return menu
    }
    
    
    

    func serverActionMenu(for server: Server) -> NSMenu {
        let menu = NSMenu(title: "test")
        let statusMenuItem = NSMenuItem(title: serverStatusText(for: server.status), action: nil, keyEquivalent: "")
        statusMenuItem.image = NSImage(named: "active")
        [
            statusMenuItem,
            NSMenuItem.separator(),
            NSMenuItem(title: "Start", action: nil, keyEquivalent: ""),
            NSMenuItem(title: "Stop", action: #selector(AppDelegate.stop), keyEquivalent: ""),
            NSMenuItem(title: "Restart", action: #selector(AppDelegate.stop), keyEquivalent: ""),
            NSMenuItem(title: "Delete", action: #selector(AppDelegate.delete), keyEquivalent: ""),
            NSMenuItem.separator(),
            NSMenuItem(title: "Copy IP", action: #selector(AppDelegate.copyIP(sender:)), keyEquivalent: server.ip ?? ""),
        ].forEach({menu.addItem($0)})
        return menu
    }


    func serverStatusText(for status: Server.Status) -> String {
        switch status {
        case .active:
            return "Active"

        case .inActive:
            return "In-active"
        }
    }
    
    @objc func noAction() {
        
    }
    
}
