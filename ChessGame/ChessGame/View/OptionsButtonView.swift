//
//  OptionsButtonView.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 30.05.2023.
//

import SwiftUI

struct OptionsButtonView: View {
    @State var isSpread: Bool = false
    let size: Double
    
    
    var body: some View {
        ZStack() {
            RoundedRectangle(cornerRadius: 100)
                .foregroundColor(Color.black)
                .frame(width: isSpread ? size * 5.1 : size, height: size)
            if (isSpread) {
                Image(systemName: "flag.fill")
                    .resizable()
                    .frame(width: size/2, height: size/2)
                    .foregroundColor(Color.white)
                    .offset(x: -135)
                
                Image(systemName: "flag.2.crossed.fill")
                    .resizable()
                    .frame(width: size/1.3, height: size/2)
                    .foregroundColor(Color.white)
                    .offset(x: -30)
                
                Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                    .resizable()
                    .frame(width: size/1.7, height: size/1.7)
                    .foregroundColor(Color.white)
                    .offset(x: 70)
            }
            
            Image(systemName: "chevron.backward")
                .resizable()
                .frame(width: size/3, height: size/2)
                .rotationEffect(.degrees(isSpread ? 0 : 180))
                .foregroundColor(Color("buttonColor"))
                .offset(x: isSpread ? size + 70 : 5)
                .onTapGesture {
                    withAnimation(.spring(response: 0.7, dampingFraction: 0.9, blendDuration: 0.7)) {
                        isSpread.toggle()
                    }
                }
            
        }.position(x: isSpread ? size * 2.1 : 0)
            .padding(50)
    }
}

struct OptionsButtonView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsButtonView(size: 70)
    }
}
