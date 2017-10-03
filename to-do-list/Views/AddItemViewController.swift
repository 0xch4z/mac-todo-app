//
//  AddItemViewController.swift
//  to-do-list
//
//  Created by Charles Kenney on 10/3/17.
//  Copyright © 2017 Charles Kenney. All rights reserved.
//

import Cocoa

class AddItemViewController: NSSplitViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var titleInput: NSTextField!
    @IBOutlet weak var isImportant: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        isImportant.state = .off
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        view.window?.title = "To Do List"
    }
    
    func alertUser(message: String, informativeText: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = message
        alert.informativeText = informativeText
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        return alert.runModal() == .alertFirstButtonReturn
    }
    
    // MARK: - Dispatch notification to reload table view
    func dispatchTableReload() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ItemsDidUpdate"), object: nil)
    }
    
    // MARK: - Resets form fields
    func resetFields() {
        titleInput.stringValue = ""
        isImportant.state = .off
    }
    
    // MARK: - Adds ToDoItem to persistant container
    @IBAction func addItem(_ sender: Any) {
        let title = titleInput.stringValue
        let important = isImportant.state == .on ? true : false
        if (title == "") {
            let _ = alertUser(message: "No Title",
                              informativeText: "You must provide a title to add your todo item!")
            return
        }
        
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            // create new todo item
            let newItem = NSEntityDescription.insertNewObject(forEntityName: "ToDoItem", into: context) as! ToDoItem
            newItem.title = title
            newItem.isImportant = important
            // save
            (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
            // clean up and dispatch
            resetFields()
            dispatchTableReload()
        }
    }
}

