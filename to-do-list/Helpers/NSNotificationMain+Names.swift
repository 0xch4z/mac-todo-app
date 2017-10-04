//
//  NSNotificationMain+Names.swift
//  to-do-list
//
//  Created by Charles Kenney on 10/4/17.
//  Copyright © 2017 Charles Kenney. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    // MARK: - Application notification names
    static let ItemsDidUpdate = Notification.Name(rawValue: "ItemsDidUpdate")
    static let ItemWasSelected = NSNotification.Name(rawValue: "ItemWasSelected")
    
}
