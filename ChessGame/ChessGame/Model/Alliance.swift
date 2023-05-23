//
//  Alliance.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 10.05.2023.
//

import Foundation

enum Alliance: CustomStringConvertible {
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
}
