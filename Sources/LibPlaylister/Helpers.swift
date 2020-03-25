//
//  Helpers.swift
//  Files
//
//  Created by Grey Patterson on 3/11/20.
//

import Foundation

extension String{
    public var markdownSafe: String{
        return self
            .replacingOccurrences(of: "*", with: #"\*"#)
            .replacingOccurrences(of: "[", with: #"\["#)
            .replacingOccurrences(of: "]", with: #"\]"#)
    }
}

public struct RuntimeError: Error, CustomStringConvertible {
    public var description: String
    
    public init(_ description: String){
        self.description = description
    }
}
