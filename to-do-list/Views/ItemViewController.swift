//
//  ItemViewController.swift
//  to-do-list
//
//  Created by Charles Kenney on 10/3/17.
//  Copyright © 2017 Charles Kenney. All rights reserved.
//

import Cocoa

class ItemViewController: NSSplitViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var titleInput: NSTextField!
    @IBOutlet weak var isImportant: NSButton!
    @IBOutlet weak var deleteButton: NSButton!
    
    
    var selectedItem: ToDoItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isImportant.state = .off
        NotificationCenter.default.addObserver(self, selector: #selector(updateSelectedItem(_:)),
                                               name: .ItemWasSelected, object: nil)
    }
    
    
    override func viewDidAppear() {
        super.viewDidAppear()
        view.window?.title = "To Do List"
    }
    
    
    // MARK: - Dispatch notification to reload table view
    func dispatchTableReload() {
        NotificationCenter.default.post(name: .ItemsDidUpdate, object: nil)
    }
    
    
    // MARK: - Resets form fields
    func resetFields() {
        titleInput.stringValue = ""
        isImportant.state = .off
    }
    
    
    // MARK: - Adds ToDoItem to persistant container
    @IBAction func addItem(_ sender: Any) {
        
        // get values for new item
        let title = titleInput.stringValue
        let important = isImportant.state == .on ? true : false
        if (title == "") {
            // return on empty title field
            let _ = UserAlertProvider.alertUser(message: "No Title", informativeText: "You must provide a title to add your todo item!")
            return
        }
        
        // get managed object context
        guard let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            print("could not get items")
            return
        }
        
        // create new todo item
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "ToDoItem", into: context) as! ToDoItem
        newItem.title = title
        newItem.isImportant = important
        // save context
        (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
        // clean up and dispatch change
        resetFields()
        dispatchTableReload()
    }
    
    
    // MARK: - Updates selected ToDoItem
    @objc func updateSelectedItem(_ notification: NSNotification) {
        
        if let item = notification.userInfo?["item"] {
            // push new selected item
            selectedItem = item as? ToDoItem
            // enable delete button
            deleteButton.isHidden = false
        }
    }
    
    
    // MARK: - Deletes ToDoItem from persistant container
    @IBAction func deleteItem(_ sender: Any) {
        
        // get context and item
        guard let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext,
            let item = selectedItem else {
                print("could not delete item")
                return
        }
        
        // delete item
        context.delete(item)
        
        // save context and dispatch change
        (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
        dispatchTableReload()
        
        // hide delete button
        deleteButton.isHidden = true
    }
    
}

