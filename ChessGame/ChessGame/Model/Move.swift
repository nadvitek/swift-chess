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
}
