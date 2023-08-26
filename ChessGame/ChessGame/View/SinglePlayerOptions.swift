//
//  SinglePlayerOptions.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 26.08.2023.
//

import SwiftUI

struct SinglePlayerOptions: View {
    @EnvironmentObject var gameSettings: GameSettings
    
    var body: some View {
        ZStack {
            Color.bg.ignoresSafeArea()
            
            VStack (spacing: 20) {
                RoundedRectangle(cornerRadius: 40)
                    .frame(width: 200, height: 120)
                    .foregroundColor(.button)
                    .overlay {
                        Text("vs AI")
                            .font(.getFont(of: 35))
                            .foregroundColor(.black)
                    }
                    .onTapGesture {
                        gameSettings.gameType = .Bot
                    }
                
                RoundedRectangle(cornerRadius: 40)
                    .frame(width: 200, height: 120)
                    .foregroundColor(.button)
                    .overlay {
                        Text("Local Device")
                            .font(.getFont(of: 35))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                    }
                    .onTapGesture {
                        gameSettings.gameType = .Offline
                    }
            }
        }
    }
}

struct SinglePlayerOptions_Previews: PreviewProvider {
    static var previews: some View {
        SinglePlayerOptions()
    }
}
