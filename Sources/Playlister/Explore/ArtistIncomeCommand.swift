//
//  ArtistIncomeCommand.swift
//  Files
//
//  Created by Grey Patterson on 2/29/20.
//

import SwiftCLI
import Foundation

// TODO: This should take an artist name, then get all their songs, and then total up the counts across all of those, and finally multiply it by Apple Music's 'payout per artist' thing

class ArtistIncomeCommand: Command {
    func execute() throws {
        <#code#>
    }
    
    let name = "income"
    
    let shortDescription: String = "Estimate the amount of money an artist has made from you listening to their music."
}
