//
//  DrawOffer.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 05.09.2023.
//

import SwiftUI

struct DrawOffer: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    @EnvironmentObject var gameSettings: GameSettings
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 260, height: 210)
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 250, height: 200)
                .foregroundColor(.button)
            VStack (spacing: 30) {
                Text("\(gameViewModel.allianceDrawOffered == .White ? gameSettings.whitePlayerName : gameSettings.blackPlayerName) offers you a draw. Do you accept?")
                    .foregroundColor(.black)
                    .font(.getFont(of: 25))
                    .frame(maxWidth: 230)
                    .multilineTextAlignment(.center)
                
                HStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.black)
                        .frame(width: 100, height: 50)
                        .overlay {
                            Text("Decline")
                                .foregroundColor(.white)
                                .font(.title3)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            
                        }
                        .shadow(radius: 5)
                        .onTapGesture {
                            gameViewModel.drawOffered = false
                    }
                    
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.black)
                        .frame(width: 100, height: 50)
                        .overlay {
                            Text("Accept")
                                .foregroundColor(.white)
                                .font(.title3)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            
                        }
                        .shadow(radius: 5)
                        .onTapGesture {
                            gameViewModel.drawOffered = false
                            gameSettings.gameResult = .Draw
                            gameViewModel.gameOver = true
                    }
                }
                
            }
        }
    }
}

struct DrawOffer_Previews: PreviewProvider {
    static var previews: some View {
        DrawOffer()
            .environmentObject(GameViewModel())
            .environmentObject(GameSettings())
    }
}
