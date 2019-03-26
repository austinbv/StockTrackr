//
//  DefaultsKeys.swift
//  StockTrackr
//
//  Created by Austin Vance on 3/26/19.
//  Copyright © 2019 Focused Labs. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    static let stocks = DefaultsKey<[String:StockModel]>("stocks", defaultValue: [String: StockModel]())
    static let pvtl = DefaultsKey<[StockModel]>("stocks", defaultValue: [])
}
