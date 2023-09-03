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
    var pieceImageName: String {
        get {
            return pieceType.description + alliance.description
        }
    }
    var hasMovedYet: Bool = false
    
    init(on tile: Tile, being type: PieceType, ofColor alliance: Alliance) {
        self.tile = tile
        self.pieceType = type
        self.alliance = alliance
    }
    
    func move(to tile: Tile) {
        self.tile = tile
        self.tile.piece = self
        hasMovedYet = true
    }
    
    func isEnemyPiece(alliance: Alliance) -> Bool {
        return self.alliance != alliance
    }
    
    func isNext(to piece: Piece) -> Bool {
        let ret = tile.y == piece.tile.y && abs(tile.x - piece.tile.x) == 1
        return ret
    }
}
