//
//  PreferencesWindow.swift
//  StockTrackr
//
//  Created by Austin Vance on 3/24/19.
//  Copyright © 2019 Focused Labs. All rights reserved.
//

import Cocoa

fileprivate enum CellIds {
    static let SYMBOL = NSUserInterfaceItemIdentifier(rawValue: "SymbolsCellID")
    static let ACTIONS = NSUserInterfaceItemIdentifier(rawValue: "ActionsCellID")
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
        var symbols = UserDefaults.standard.stringArray(forKey: "symbols")!
        symbols.append(symbolTextField.stringValue.uppercased())
        UserDefaults.standard.set(symbols, forKey: "symbols")
        symbolTextField.stringValue = ""
        symbolsTable.reloadData()
        delegate?.preferencesDidUpdate()
        
        NSLog("saved symbols: %@", UserDefaults.standard.stringArray(forKey: "symbols") ?? "Nothing there")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        symbolsTable.delegate = self
        symbolsTable.dataSource = self
        symbolsTable.reloadData()
        
        print(stockArray)
        
        self.symbolTextField.stringValue = UserDefaults
            .standard
            .string(forKey: "symbol") ?? ""
        
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @IBAction func clicked(_ sender: NSButton) {
        var symbols = UserDefaults.standard.stringArray(forKey: "symbols")!
        symbols.remove(at: sender.tag)
        UserDefaults.standard.set(symbols, forKey: "symbols")
        symbolsTable.reloadData()
        
    }
    
    
}

extension PreferencesWindow: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        let symbols = UserDefaults.standard.stringArray(forKey: "symbols") ?? []
        return symbols.count
    }
}

extension PreferencesWindow: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let theRow = UserDefaults.standard.stringArray(forKey: "symbols") ?? []
        NSLog("Table Column Value: %@", (tableColumn?.identifier)!.rawValue)
        
        switch tableColumn?.identifier {
        case CellIds.SYMBOL:
            let cell = tableView.makeView(withIdentifier: (tableColumn?.identifier)!, owner: self) as? NSTableCellView
            cell?.textField?.stringValue = theRow[row]
            return cell
        case CellIds.PRICE:
            let cell = tableView.makeView(withIdentifier: (tableColumn?.identifier)!, owner: self) as? NSTableCellView
            StockAPI().fetchSymbol(theRow[row], success: { json in
                DispatchQueue.main.async {
                    cell?.textField?.stringValue = String(format: "%.2f", json["latestPrice"].doubleValue)
                    cell?.textField?.textColor = json["changePercent"].doubleValue < 0 ? .red : .green
                }
            })
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
