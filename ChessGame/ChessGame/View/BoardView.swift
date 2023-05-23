//
//  BoardView.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 22.05.2023.
//

import SwiftUI

struct BoardView: View {
    let letters = ["A", "B", "C", "D", "E", "F", "G", "H"]
    
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                let size = geo.size.width * 0.9
                
                Rectangle()
                    .frame(width: size, height: size)
                .foregroundColor(Color("boardColor"))
                
                ForEach(0..<8, id: \.self) { x in
                    ForEach(0..<8, id: \.self) { y in
                        TileView(tile: Tile(x: x, y: y))
                    }
                }
                
                VStack {
                    let offset = size * 0.053
                    ForEach(0..<8) { i in
                        Text(String(8 - i))
                            .font(.headline)
                            .foregroundColor(.white)
                            .offset(y: offset * Double(i))
                    }
                }.position(x: size * 0.085, y: size * 0.89)
                
                HStack {
                    let offset = size * 0.053
                    ForEach(0..<8) { i in
                        Text(letters[i])
                            .font(.headline)
                            .foregroundColor(.white)
                            .offset(x: offset * Double(i))
                    }
                    
                }.position(x: size * 0.37, y: size * 1.54)
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}

struct TileView: View {
    @State private var tile: Tile
    
    init(tile: Tile) {
        self.tile = tile
        if (tile.y == 1) {
            tile.piece = Piece(on: tile, being: .Pawn, ofColor: .White)
        }
        if (tile.y == 6) {
            tile.piece = Piece(on: tile, being: .Pawn, ofColor: .Black)
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            let size = geo.size.width * 0.099
            let positionX = geo.size.width * 0.153 + size * Double(tile.x)
            let positionY = geo.size.height * 0.6794 - size * Double(tile.y)
            ZStack {
                Button (action: {
                    tile.piece = Piece(on: tile, being: .Queen, ofColor: .Black)
                    print("a")
                }) {
                    Text(" a")
                }
                    .frame(width: size, height: size)
                    .background((tile.x + tile.y) % 2 == 0 ? Color("darkTileColor") : Color("lightTileColor"))
                
                if let tilePiece = tile.piece {
                    Image(tilePiece.pieceImageName())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: size * 1.3, height: size * 1.3, alignment: .center)
                }
                
            }.position(x: positionX, y: positionY)
        }
    }
}



struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
    }
}
