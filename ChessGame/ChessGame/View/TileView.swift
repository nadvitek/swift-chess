//
//  TileView.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 25.05.2023.
//

import SwiftUI

struct TileView: View {
    @ObservedObject var tile: Tile
    let tileSize: Double
    let action: () -> Void
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(decideTileColor())
                .frame(width: tileSize, height: tileSize)
            if let pieceOnTile = tile.piece {
                Image(pieceOnTile.pieceImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: tileSize, height: tileSize, alignment: .center)
            }
            
            Circle()
                .foregroundColor(.green)
                .frame(width: tile.isTargetTile && tile.isEmpty ? tileSize * 0.6 : 0, height: tile.isTargetTile && tile.isEmpty ? tileSize * 0.6 : 0)
        }
        .onTapGesture {
                action()
        }
    }
    
    
    func decideTileColor() -> Color {
        if (tile.isTargetTile) {
            if (!tile.isEmpty) {
                return Color.red
            }
        }
        
        return Color((tile.x + tile.y) % 2 == 0 ? "darkTileColor" : "lightTileColor")
    }
}
