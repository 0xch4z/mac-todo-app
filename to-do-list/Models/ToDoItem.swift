//
//  ToDoItem.swift
//  to-do-list
//
//  Created by Charles Kenney on 10/3/17.
//  Copyright © 2017 Charles Kenney. All rights reserved.
//

import Foundation
import CoreData

@objc(ToDoItem)
class ToDoItem: NSManagedObject {
    
    func debugInfo() {
        
        print("title: \(title ?? "")")
        print(isImportant ? "important" : "not important")
    }
    
}
