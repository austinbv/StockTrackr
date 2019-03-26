//
//  StatusMenuController.swift
//  StockTrackr
//
//  Created by Austin Vance on 3/22/19.
//  Copyright © 2019 Focused Labs. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject, PreferencesWindowDelegate {
    let upSymbol = "▲"
    let downSymbol = "▼"
    let stockAPI = StockAPI()
    var preferencesWindow : PreferencesWindow!
    var timer: Timer?
    
   
    @IBOutlet weak var stockArray: NSArrayController!
    @IBOutlet weak var statusMenu: NSMenu!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    @IBAction func quitClicked(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func preferencesClicked(_ sender: Any) {
        preferencesWindow.showWindow(nil)
    }
    
    func preferencesDidUpdate() {
        self.timer?.invalidate()
        self.updateSymbol(0)
    }
    
    override func awakeFromNib() {
        self.preferencesWindow = PreferencesWindow()
        self.preferencesWindow.delegate = self
        statusItem.button?.title = "StockTrackr..."
        statusItem.menu = statusMenu
        
        print(stockArray)

        self.updateSymbol(0)
    }
    
    private func updateSymbol(_ index: Int) {
        let defaults = UserDefaults.standard
        let symbols = defaults.stringArray(forKey: "symbols") ?? []

        let i = symbols.count < index + 1 ? 0 : index
        
        self.stockAPI.fetchSymbol(symbols[i]) { quote in
            let isUp = quote["changePercent"] >= 0
            let indicator = isUp ? self.upSymbol : self.downSymbol
            let percentChange = String(format: "%.2f", abs(quote["changePercent"].doubleValue))
            let price = String(format: "%.2f", abs(quote["latestPrice"].doubleValue))
            
            DispatchQueue.main.async {
                self.statusItem.button?.title = "\(quote["symbol"]) \(indicator) \(price) (\(percentChange))"
                self.statusItem.button?.contentTintColor = isUp ? .green : .red
            }
        }
        
        let next = symbols.count == i + 1 ? 0 : i + 1
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { timer in
            self.updateSymbol(next)
        })
    }
}
