//
//  Alliance.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 10.05.2023.
//

import Foundation

enum Alliance: String, CustomStringConvertible {
    case White
    case Black
    
    var description: String {
        switch self {
        case .White:
            return "White"
        case .Black:
            return "Black"
        }
    }
    
    var switchAlliance: Alliance {
        switch self {
        case .White:
            return .Black
        case .Black:
            return .White
        }
    }
}
