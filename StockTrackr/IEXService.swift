//
//  IEXService.swift
//  StockTrackr
//
//  Created by Austin Vance on 3/22/19.
//  Copyright © 2019 Focused Labs. All rights reserved.
//

import Cocoa
import SwiftyJSON

class IEXService: NSObject {    
    func fetchSymbol(_ symbol: String, success: @escaping (Stock) -> Void) {
        let session = URLSession.shared
        let url = URL(string: "https://api.iextrading.com/1.0/stock/\(symbol)/quote")
        let task = session.dataTask(with: url!) { data, response, err in
            if let error = err {
                NSLog("There was an error: \(error)")
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    let json = JSON(data!)

                    success(
                        Stock(
                            symbol: json["symbol"].stringValue,
                            price: json["latestPrice"].doubleValue,
                            changePercent: json["changePercent"].doubleValue
                        )
                    )
                default:
                    NSLog("response is %d, %@", httpResponse.statusCode, HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                    
                }
            }
        }
        task.resume()
    }

}
