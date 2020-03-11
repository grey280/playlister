//
//  RatingFormatter.swift
//  Files
//
//  Created by Grey Patterson on 3/11/20.
//

import Foundation

public protocol RatingFormatter {
    
    /// Format a rating
    /// - Parameter rating: the rating, on the scale 0-100
    func format(_ rating: Int) -> String
}

public extension RatingFormatter{
    static func fiveStar() -> RatingFormatter{
        FiveStarRatingFormatter()
    }
}

private struct FiveStarRatingFormatter: RatingFormatter {
    func format(_ rating: Int) -> String {
        var rate = rating
        if rate < 0 {
            rate = 0
        } else if rate > 100 {
            rate = 100
        }
        rate = rate / 20
        var unrate = 5 - rate
        if unrate < 0 {
            unrate = 0
        }
        let yes = String(repeating: "★", count: rate)
        let no = String(repeating: "☆", count: unrate)
        return yes + no
    }
}
