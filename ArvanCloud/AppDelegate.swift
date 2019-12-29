//
//  AppDelegate.swift
//  ArvanCloud
//
//  Created by Hadi Sharghi on 12/26/19.
//  Copyright © 2019 Hadi Sharghi. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusBarItem: NSStatusItem!
    var menuBuilder: MenuBuilder!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {

        print(toggleDockIcon(showIcon: false))
        
        let statusBar = NSStatusBar.system
        statusBarItem = statusBar.statusItem(
            withLength: NSStatusItem.squareLength)
        statusBarItem.button?.title = "🌯"

        let statusBarMenu = NSMenu(title: "Cap Status Bar Menu")
        statusBarItem.menu = statusBarMenu

        guard let menu = self.statusBarItem.menu else {
            return
        }
        
        self.menuBuilder = MenuBuilder(menu: menu)


        Region.getAll { (regions, error) in
            
            regions?.forEach { region  in
                guard let code = region.code else {
                    return
                }
                Server.get(for: code) { (servers, error) in
                    region.servers = servers ?? []
                    self.menuBuilder.updateMenu()
                }
            }
            self.menuBuilder.regions = regions ?? []
        }
        
        
    }
    
    @objc func orderABurrito(sender: Any) {
        print(sender)
        print("Ordering a burrito!")
    }


    @objc func cancelBurritoOrder() {
        print("Canceling your order :(")
    }
    
    @objc func copyIP(sender: Any) {
        if let item = sender as? NSMenuItem {
            print(item.keyEquivalent)
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(item.keyEquivalent, forType: .string)
            NSPasteboard.general.string(forType: .string)
        }
    }
    
    @objc func showPreferences() {
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


    func toggleDockIcon(showIcon state: Bool) -> Bool {
        var result: Bool
        if state {
            result = NSApp.setActivationPolicy(NSApplication.ActivationPolicy.regular)
        }
        else {
            result = NSApp.setActivationPolicy(NSApplication.ActivationPolicy.accessory)
        }
        return result
    }

}

