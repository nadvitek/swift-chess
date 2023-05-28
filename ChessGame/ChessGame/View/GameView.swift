//
//  GameView.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 22.05.2023.
//

import SwiftUI

struct GameView: View {
    @StateObject var gameViewModel = GameViewModel()
    let letters = ["A", "B", "C", "D", "E", "F", "G", "H"]
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Rectangle()
                    .fill()
                    .ignoresSafeArea()
                    .foregroundColor(Color("backgroundColor"))
                let size = geo.size.width * 0.9
                
                Rectangle()
                    .frame(width: size + 1, height: size + 1)
                    .foregroundColor(Color("boardFrameColor"))
                
                
                Rectangle()
                    .frame(width: size, height: size)
                .foregroundColor(Color("boardColor"))
                
                BoardView(size: size).environmentObject(gameViewModel)
                
                
                
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

struct BoardView: View {
    @StateObject var boardViewModel = BoardViewModel()
    @EnvironmentObject var gameViewModel: GameViewModel
    let boardSize: Double
    
    
    init(size: Double) {
        self.boardSize = size
    }
    
    var body: some View {
        ZStack {
            HStack(spacing:1) {
                ForEach((0..<8), id:\.self) { x in
                    VStack(spacing:1) {
                        ForEach((0..<8).reversed(), id:\.self) { y in
                            TileView(tile: boardViewModel.board[y][x], tileSize: boardSize * 0.106, action: {self.tileAction(x: x, y: y)})
                        }
                    }
                }
            }
            
            if (boardViewModel.processingPromotion) {
                PromotionView(size: boardSize, piece: boardViewModel.promotedPiece!, action: {finishPromotion()})
                    .offset(y: boardSize * 0.68 * (boardViewModel.promotedPiece?.alliance == .White ? 1 : -1))
            }
        }
    }
    
    func finishPromotion() {
        boardViewModel.promotedPiece = nil
    }
    
    func tileAction(x: Int, y: Int) {
        boardViewModel.processTile(x: x, y: y)
    }
}

struct TileView: View {
    @ObservedObject var tile: Tile
    let tileSize: Double
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            if let pieceOnTile = tile.piece {
                Image(pieceOnTile.pieceImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: tileSize, height: tileSize, alignment: .center)
            } else {
                Rectangle()
                    .foregroundColor(decideTileColor())
            }
        }
            .frame(width: tileSize, height: tileSize)
            .background(decideTileColor())
    }
    
    
    func decideTileColor() -> Color {
        if (tile.isTargetTile) {
            if (!tile.isEmpty) {
                return Color.red
            }
            return Color.green
        }
        
        return Color((tile.x + tile.y) % 2 == 0 ? "darkTileColor" : "lightTileColor")
    }
}


struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
