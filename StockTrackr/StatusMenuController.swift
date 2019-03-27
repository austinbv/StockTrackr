//
//  StatusMenuController.swift
//  StockTrackr
//
//  Created by Austin Vance on 3/22/19.
//  Copyright © 2019 Focused Labs. All rights reserved.
//

import Cocoa
import SwiftyUserDefaults

class StatusMenuController: NSObject, PreferencesWindowDelegate {
    
    @IBOutlet weak var updatedTIme: NSMenuItem!
    let iexService = IEXService()
    var preferencesWindow : PreferencesWindow!
    var timer: Timer?
    var updateTimer: Timer?
    var stockItems: [NSMenuItem] = []
    
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
        self.updateTimer?.invalidate()
        
        self.updateStocks()
        self.startRotation()
    }
    
    private func setStockItems() {
        self.stockItems.forEach { item in
            self.statusMenu.removeItem(item)
        }
        
        stockItems = Defaults[.stocks].map { aStock in
            let stock = StockPresenter(aStock)
            
            let coloredString = NSAttributedString(
                string: "\(stock.symbol) \(stock.indicatorSymbol) \(stock.price) (\(stock.changePercent))",
                attributes: [NSAttributedString.Key.foregroundColor : stock.color]
            )
            
            let item = NSMenuItem()
            item.attributedTitle = coloredString
            statusMenu.insertItem(item, at: 0)
            
            return item
        }   
    }
    
    override func awakeFromNib() {
        self.preferencesWindow = PreferencesWindow()
        self.preferencesWindow.delegate = self
        statusItem.button?.title = "StockTrackr..."
        statusItem.menu = statusMenu
        
        self.updateStocks()
        self.startRotation()
    }
    
    private func updateStocks() {
        self.updateTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            Defaults[.stocks].enumerated().forEach { index, stock in
                IEXService().fetchSymbol(stock.symbol) { updated in
                    Defaults[.stocks][index] = updated
                }
            }
        }
    }
    
    private func startRotation(_ index: Int = 0) {
        if Defaults[.stocks].isEmpty {
            return
        }
        
        self.setStockItems()
        
        let stock = StockPresenter(Defaults[.stocks][index])
        let i = Defaults[.stocks].count < index + 1 ? 0 : index
        
        DispatchQueue.main.async {
            self.statusItem.button?.title = "\(stock.symbol) \(stock.indicatorSymbol) \(stock.price) (\(stock.changePercent))"
            self.statusItem.button?.contentTintColor = stock.color
        }
        
        let next = Defaults[.stocks].count == i + 1 ? 0 : i + 1
        self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { timer in
            self.startRotation(next)
        })
    }
}
