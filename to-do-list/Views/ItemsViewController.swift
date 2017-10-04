//
//  ItemsViewController.swift
//  to-do-list
//
//  Created by Charles Kenney on 10/3/17.
//  Copyright © 2017 Charles Kenney. All rights reserved.
//

import Cocoa

class ItemsViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet weak var tableView: NSTableView!
    
    
    var items: [ToDoItem] = []
    
    
    static let titleCellId = "TitleCell"
    static let importantCellId = "ImportantCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(getToDoItems),
                                               name: .ItemsDidUpdate, object: nil)
    }
    
    
    override func viewWillAppear() {
        getToDoItems()
    }
    
    
    // MARK: - Dispatch notification to reload table view
    func dispatchTableReload() {
        NotificationCenter.default.post(name: .ItemsDidUpdate, object: nil)
    }
    
    
    // MARK: - Fetch ToDoItems
    @objc func getToDoItems() {
        guard let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            print("could not fetch")
            return
        }
        // fetch items and debug
        do {
            items = try context.fetch(ToDoItem.fetchRequest())
            items.forEach { item in
                item.debugInfo()
            }
        } catch {}
        // reload table data
        tableView.reloadData()
    }
    
    
    // MARK: - Set number of rows
    func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count
    }
    
    
    // MARK: - Set up table
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let item = items[row]
        // determine column to render
        if (tableColumn?.identifier) != .Important {
            // make important column cell
            if let cell = tableView.makeView(withIdentifier: .Important, owner: self) as? NSTableCellView {
                cell.textField?.stringValue = item.isImportant ? "\u{2757}" : ""
                return cell
            }
        } else {
            // make title column cell
            if let cell = tableView.makeView(withIdentifier: .Title, owner: self) as? NSTableCellView {
                cell.textField?.stringValue = item.title ?? ""
                return cell
            }
        }
        return nil
    }
    
    
    // MARK: - Dispatch selection did change and post item
    func tableViewSelectionDidChange(_ notification: Notification) {
        if (tableView.selectedRow == -1) {
            // exit if header selected!
            return
        }
        // post notification with item
        let item = items[tableView.selectedRow]
        NotificationCenter.default.post(name: .ItemWasSelected, object: nil, userInfo: ["item": item])
    }
    
}
