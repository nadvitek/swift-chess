//
//  Move.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 23.05.2023.
//

import Foundation

class Move {
    let sourceTile: Tile
    let destinationTile: Tile
    let piece: Piece
    
    init(from sourceTile: Tile, to destinationTile: Tile, with piece: Piece) {
        self.sourceTile = sourceTile
        self.destinationTile = destinationTile
        self.piece = piece
    }
    
    func isPromotionMove() -> Bool {
        return piece.pieceType == .Pawn && (destinationTile.y == 7 || destinationTile.y == 0)
    }
    
    func isEnPassanteMove() -> Bool {
        return piece.pieceType == .Pawn && destinationTile.x != sourceTile.x && destinationTile.isEmpty
    }
    
    func isSmallCastleMove() -> Bool {
        return piece.pieceType == .King && destinationTile.x == (piece.tile.x + 2)
    }
    
    func isBigCastleMove() -> Bool {
        return piece.pieceType == .King && destinationTile.x == (piece.tile.x - 3)
    }
    
    func isPawnTwoStepMove() -> Bool {
        return piece.pieceType == .Pawn && abs(destinationTile.y - sourceTile.y) == 2
    }
    
    
}
