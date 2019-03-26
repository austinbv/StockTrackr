//
//  StockModel.swift
//  StockTrackr
//
//  Created by Austin Vance on 3/26/19.
//  Copyright © 2019 Focused Labs. All rights reserved.
//

import Cocoa
import SwiftyUserDefaults

final class StockModel: Codable, DefaultsSerializable {
    let price: Double
    let symbol: String
    
    init(price: Double, symbol: String) {
        self.price = price
        self.symbol = symbol
    }
}
