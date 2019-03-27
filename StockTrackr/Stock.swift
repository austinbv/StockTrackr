//
//  StockModel.swift
//  StockTrackr
//
//  Created by Austin Vance on 3/26/19.
//  Copyright © 2019 Focused Labs. All rights reserved.
//

import Cocoa
import SwiftyUserDefaults

struct Stock: Codable, DefaultsSerializable {
    let symbol: String
    let price: Double
    let changePercent: Double
    var isUp: Bool {
        return changePercent >= 0
    }
}

struct StockPresenter {
    private let stock: Stock,
    upSymbol = "▲",
    downSymbol = "▼"
    init(_ stock: Stock) {
        self.stock = stock
    }
    
    var symbol: String {
        return stock.symbol.uppercased()
    }
    
    var price: String {
        return String(format: "%.2f", abs(stock.price))
    }
    
    var changePercent: String {
        return String(format: "%.2f", abs(stock.changePercent) * 100)
    }
    
    var indicatorSymbol: String {
        return stock.isUp ? self.upSymbol : self.downSymbol
    }
    
    var color: NSColor {
        return stock.isUp ? NSColor(deviceRed: 0, green: 1, blue: 0, alpha: 0.5) : NSColor(deviceRed: 1, green: 0.2, blue: 0, alpha: 0.85)
    }
}

