//
//  PieceType.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 10.05.2023.
//

import Foundation

enum PieceType: CustomStringConvertible {
    case Pawn
    case Knight
    case Bishop
    case Rook
    case Queen
    case King
    
    var description: String {
        switch self {
        case .Pawn:
            return "pawn"
        case .Knight:
            return "knight"
        case .Bishop:
            return "bishop"
        case .Rook:
            return "rook"
        case .Queen:
            return "queen"
        case .King:
            return "king"
        }
    }
}
