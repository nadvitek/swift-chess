//
//  Piece.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 10.05.2023.
//

import Foundation

class Piece {
    var tile: Tile
    let pieceType: PieceType
    let alliance: Alliance
    
    init(on tile: Tile, being type: PieceType, ofColor alliance: Alliance) {
        self.tile = tile
        self.pieceType = type
        self.alliance = alliance
    }
    
    func moveWithPiece(to tile: Tile) {
        self.tile = tile
    }
}
