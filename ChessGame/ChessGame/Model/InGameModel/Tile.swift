//
//  Tile.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 10.05.2023.
//

import Foundation

class Tile: NSObject, ObservableObject, NSCopying {
    @Published var piece: Piece?
    let x: Int
    let y: Int
    var isEmpty: Bool {
        get {
            piece == nil
        }
    }
    @Published var isTargetTile: Bool = false
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    func compareTo(other: Tile) -> Bool {
        return self.x == other.x && self.y == other.y
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Tile(x: x, y: y)
        if let copiedPiece = self.piece {
            copy.piece = Piece(on: copy, being: copiedPiece.pieceType, ofColor: copiedPiece.alliance)
            copy.piece?.hasMovedYet = copiedPiece.hasMovedYet
        }
        return copy
    }
}
