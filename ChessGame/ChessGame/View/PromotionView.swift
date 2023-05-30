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
                
                Button {
                    tile.piece = Piece(on: tile, being: .Queen, ofColor: piece!.alliance)
                    action()
                } label: {
                    Image("queen\(piece!.alliance.description)")
                        .resizable()
                        .frame(width: size * 0.17, height: size * 0.17)
                }
                
                Button {
                    tile.piece = Piece(on: tile, being: .Rook, ofColor: piece!.alliance)
                    action()
                } label: {
                    Image("rook\(piece!.alliance.description)")
                        .resizable()
                        .frame(width: size * 0.17, height: size * 0.17)
                }
                
                Button {
                    tile.piece = Piece(on: tile, being: .Bishop, ofColor: piece!.alliance)
                    action()
                } label: {
                    Image("bishop\(piece!.alliance.description)")
                        .resizable()
                        .frame(width: size * 0.17, height: size * 0.17)
                }
                
                Button {
                    tile.piece = Piece(on: tile, being: .Knight, ofColor: piece!.alliance)
                    action()
                } label: {
                    Image("knight\(piece!.alliance.description)")
                        .resizable()
                        .frame(width: size * 0.17, height: size * 0.17)
                }
            }
        }
    }
}

struct PromotionView_Previews: PreviewProvider {
    static var previews: some View {
        PromotionView(size: 300, piece: Piece(on: Tile(x: 0, y: 0), being: .Pawn, ofColor: .White), action: {print("hi")})
    }
}
