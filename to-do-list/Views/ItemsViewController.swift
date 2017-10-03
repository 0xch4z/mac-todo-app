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
    
    static let titleCellId = "TitleCell"
    static let importantCellId = "ImportantCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        getToDoItems()
        NotificationCenter.default.addObserver(self, selector: #selector(getToDoItems),
                    name: NSNotification.Name(rawValue: "ItemsDidUpdate"), object: nil)
    }
    
    override func viewWillAppear() {
        getToDoItems()
    }
    
    var items: [ToDoItem] = []
    
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
        if (tableColumn?.identifier)!.rawValue == "Important" {
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "Important"), owner: self) as? NSTableCellView {
                cell.textField?.stringValue = item.isImportant ? "\u{2757}" : ""
                return cell
            }
        } else {
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "Title"), owner: self) as? NSTableCellView {
                cell.textField?.stringValue = item.title ?? ""
                return cell
            }
        }
        return nil
    }
    
}
