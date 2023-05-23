//
//  Tile.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 10.05.2023.
//

import Foundation

class Tile {
    var x: Int
    var y: Int
    var piece: Piece?
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}
