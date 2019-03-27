//
//  PreferencesWindow.swift
//  StockTrackr
//
//  Created by Austin Vance on 3/24/19.
//  Copyright © 2019 Focused Labs. All rights reserved.
//

import Cocoa
import SwiftyUserDefaults

fileprivate enum CellIds {
    static let SYMBOL = NSUserInterfaceItemIdentifier(rawValue: "SymbolsCellID")
    static let ACTIONS = NSUserInterfaceItemIdentifier(rawValue: "ActionsCellID")
    static let PERCENT_CHANGE = NSUserInterfaceItemIdentifier(rawValue: "PercentChangeCellID")
    static let PRICE = NSUserInterfaceItemIdentifier(rawValue: "PriceCellID")
}

protocol PreferencesWindowDelegate {
    func preferencesDidUpdate()
}

class PreferencesWindow: NSWindowController,
NSWindowDelegate {
    @IBOutlet weak var symbolTextField: NSTextField!
    @IBOutlet weak var symbolsTable: NSTableView!
    @IBOutlet var stockArray: NSArrayController!
    
    var delegate: PreferencesWindowDelegate?
    
    override var windowNibName : String! {
        return "PreferencesWindow"
    }
    
    @IBAction func add(_ sender: Any) {
        if symbolTextField.stringValue.isEmpty {
            return
        }
        
        IEXService().fetchSymbol(symbolTextField.stringValue.uppercased()) { stock in
            Defaults[.stocks].append(stock)
            DispatchQueue.main.async {
                self.symbolTextField.stringValue = ""
                self.symbolsTable.reloadData()
                self.delegate?.preferencesDidUpdate()
            }
            
            
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        symbolsTable.delegate = self
        symbolsTable.dataSource = self
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.symbolsTable.reloadData()
        }
        
        self.symbolTextField.stringValue = UserDefaults
            .standard
            .string(forKey: "symbol") ?? ""
        
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @IBAction func clicked(_ sender: NSButton) {
        Defaults[.stocks].remove(at: sender.tag)
        symbolsTable.reloadData()
        self.delegate?.preferencesDidUpdate()
    }
    
}

extension PreferencesWindow: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return Defaults[.stocks].count
    }
}

extension PreferencesWindow: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let stock = StockPresenter(Defaults[.stocks][row])
        
        
        switch tableColumn?.identifier {
        case CellIds.SYMBOL:
            let cell = tableView.makeView(withIdentifier: (tableColumn?.identifier)!, owner: self) as? NSTableCellView
            cell?.textField?.stringValue = stock.symbol
            return cell
        case CellIds.PRICE:
            let cell = tableView.makeView(withIdentifier: (tableColumn?.identifier)!, owner: self) as? NSTableCellView
            cell?.textField?.stringValue = stock.price
            cell?.textField?.textColor = stock.color
            return cell
        case CellIds.PERCENT_CHANGE:
            let cell = tableView.makeView(withIdentifier: (tableColumn?.identifier)!, owner: self) as? NSTableCellView
            cell?.textField?.stringValue = stock.changePercent
            cell?.textField?.textColor = stock.color
            return cell
        case CellIds.ACTIONS:
            let cell = NSButton(title: "x", target: self, action: #selector(clicked(_:)))
            cell.bezelStyle = NSButton.BezelStyle.inline
            cell.tag = row
            return cell
        default:
            return nil
        }
    }
}
