//
//  DatabaseCommandGroup.swift
//  Files
//
//  Created by Grey Patterson on 2/16/20.
//

import Foundation
import SwiftCLI

class DatabaseCommandGroup: CommandGroup {
    let children: [Routable] = [DatabaseInitCommand()]
    
    var shortDescription: String = "Manage the links database"
    
    let name = "database"
}
