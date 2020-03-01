//
//  ExploreCommandGroup.swift
//  Files
//
//  Created by Grey Patterson on 2/29/20.
//

import Foundation
import SwiftCLI

class ExploreCommandGroup: CommandGroup {
    let children: [Routable] = [ArtistIncomeCommand()]
    
    var shortDescription: String = "Explore your library"
    
    let name = "explore"
    
    
}
