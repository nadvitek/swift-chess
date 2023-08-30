//
//  PromotionView.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 27.05.2023.
//

import SwiftUI

struct PromotionView: View {
    let size: Double
    var piece: Piece?
    let action: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size/10)
                .frame(width: size, height: size * 0.2)
                .foregroundColor(Color("boardColor"))
                .overlay(
                    RoundedRectangle(cornerRadius: size/10)
                        .stroke(Color("buttonColor"), lineWidth: 4)
                )
            
            HStack(spacing: 15) {
                let tile = piece!.tile
                
                createPieceButton(tile: tile, pieceType: .Queen)
                
                createPieceButton(tile: tile, pieceType: .Rook)
                
                createPieceButton(tile: tile, pieceType: .Bishop)
                
                createPieceButton(tile: tile, pieceType: .Knight)
                
            }
        }
    }
    
    func createPieceButton(tile: Tile, pieceType: PieceType) -> Button<some View> {
        Button {
            tile.piece = Piece(on: tile, being: pieceType, ofColor: piece!.alliance)
            action()
        } label: {
            Image("\(pieceType.description)\(piece!.alliance.description)")
                .resizable()
                .frame(width: size * 0.17, height: size * 0.17)
        }
    }
}

struct PromotionView_Previews: PreviewProvider {
    static var previews: some View {
        PromotionView(size: 300, piece: Piece(on: Tile(x: 0, y: 0), being: .Pawn, ofColor: .White), action: {print("hi")})
    }
}
