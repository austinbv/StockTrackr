//
//  ButtonCell.swift
//  StockTrackr
//
//  Created by Austin Vance on 3/24/19.
//  Copyright © 2019 Focused Labs. All rights reserved.
//

import Cocoa

class ButtonCell: NSButton {
    let symbol: String
    
    init(_ selector: Selector, target: Any?, symbol: String) {
        self.symbol = symbol
        super.init(title: "x", target: target, action: selector)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
