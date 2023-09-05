//
//  HistoryItemView.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 23.08.2023.
//

import SwiftUI

let game = Game(id: "1", date: Date(timeIntervalSince1970: 1692812969), whitePlayer: "Jennky", blackPlayer: "Firecracker", result: .WhiteWin)

struct HistoryItemView: View {
    let game: Game
    var bgColor: Color = .button.opacity(0.8)
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 360, height: 150)
                .padding()
                .shadow(color: .gray, radius: 25, x: 10, y: 10)
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(bgColor)
                .frame(width: 350, height: 140)
                .padding()
                .overlay {
                    VStack (spacing: 30) {
                        Text(game.date.formatted(date: .numeric, time: .shortened))
                            .font(.getFont(of: 20))
                            .foregroundColor(.black)
                        
                        HStack (alignment: .center, spacing: 5) {
                            Image("pawnWhite")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50)
                                .foregroundColor(.black)
                            generateText(game.whitePlayer)
                            generateText(game.result.getWhiteScore())
                            generateText(" : ")
                            generateText(game.result.getBlackScore())
                            generateText(game.blackPlayer)
                            Image("pawnBlack")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50)
                        }
                    }
            }
        }
    }
    
    func generateText(_ text: String) -> Text {
        return Text(text)
            .font(.getFont(of: 18))
            .foregroundColor(.black)
    }
}

struct HistoryItemView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryItemView(game: game)
    }
}
