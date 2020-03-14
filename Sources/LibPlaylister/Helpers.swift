//
//  Helpers.swift
//  Files
//
//  Created by Grey Patterson on 3/11/20.
//

import Foundation

func printedRating(_ rating: Int) -> String {
    var rate = rating
    if rate < 0 {
        rate = 0
    }
    rate = rate / 20
    var unRate = 5 - rate
    if unRate < 0 {
        unRate = 0
    }
    let yes = String(repeating: "★", count: rate)
    let no = String(repeating: "☆", count: unRate)
    return yes + no
}

extension String{
    public var markdownSafe: String{
        return self.replacingOccurrences(of: "*", with: "\\*").replacingOccurrences(of: "[", with: "\\[").replacingOccurrences(of: "]", with: "\\]")
    }
}

public struct RuntimeError: Error, CustomStringConvertible {
    public var description: String
}
