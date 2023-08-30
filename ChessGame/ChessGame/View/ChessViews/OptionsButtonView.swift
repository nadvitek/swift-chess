//
//  OptionsButtonView.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 30.05.2023.
//

import SwiftUI

struct OptionsButtonView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    
    @State var isSpread: Bool = false
    @State var iconsShowed: Bool = false
    let size: Double
    let alliance: Alliance
    
    
    
    var body: some View {
        ZStack() {
            RoundedRectangle(cornerRadius: 100)
                .foregroundColor(Color("boardColor"))
                .frame(width: isSpread ? size * 6 : size, height: size)
            if (iconsShowed) {
                Image(systemName: "flag.fill")
                    .resizable()
                    .frame(width: size/2, height: size/2)
                    .foregroundColor(Color.white)
                    .rotationEffect(.degrees(alliance == .White ? 180 : 0))
                    .offset(x: -135)
                    .onTapGesture {
                        giveUp()
                    }
                
                Image(systemName: "flag.2.crossed.fill")
                    .resizable()
                    .frame(width: size/1.3, height: size/2)
                    .foregroundColor(Color.brown)
                    .rotationEffect(.degrees(alliance == .White ? 180 : 0))
                    .offset(x: -30)
                    .onTapGesture {
                        gameViewModel.drawOffered = true
                    }
                
                Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                    .resizable()
                    .frame(width: size/1.7, height: size/1.7)
                    .foregroundColor(Color.gray)
                    .rotationEffect(.degrees(alliance == .White ? 180 : 0))
                    .offset(x: 70)
                    .onTapGesture {
                        gameViewModel.reverse()
                    }
            }
            
            Image(systemName: "chevron.backward")
                .resizable()
                .frame(width: size/3, height: size/2)
                .rotationEffect(.degrees(isSpread ? 0 : 180))
                .foregroundColor(Color("buttonColor"))
                .offset(x: isSpread ? size * 2.5 : 3)
                .onTapGesture {
                    withAnimation(.spring(response: 1.2, dampingFraction: 0.9, blendDuration: 0.7)) {
                        isSpread.toggle()
                    }
                    
                    if (!isSpread) {
                        iconsShowed.toggle()
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
                            withAnimation(.spring()) {
                                iconsShowed.toggle()
                            }
                        }
                    }
                    
                }
        }.position(x: isSpread ? size * 2.5 : 0)
            .padding(50)
            .offset(y: alliance == Alliance.White ? -40 : -40)
            .rotationEffect(.degrees(alliance == .White ? 180 : 0))
    }
    
    func giveUp() {
        gameViewModel.playersTurn = gameViewModel.isReversed ? alliance.switchAlliance : alliance
        gameViewModel.gameOver = true
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            OptionsButtonView(size: geo.size.width * 0.15, alliance: .White)
        }
    }
}
