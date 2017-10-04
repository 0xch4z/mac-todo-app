//
//  AlertUser.swift
//  to-do-list
//
//  Created by Charles Kenney on 10/4/17.
//  Copyright © 2017 Charles Kenney. All rights reserved.
//

import Foundation
import Cocoa

final class UserAlertProvider {
    
    static func alertUser(message: String, informativeText: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = message
        alert.informativeText = informativeText
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        return alert.runModal() == .alertFirstButtonReturn
    }
    
}
