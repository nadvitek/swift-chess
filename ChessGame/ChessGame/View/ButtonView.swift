//
//  ButtonView.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 12.05.2023.
//

import SwiftUI

struct ButtonView: View {
    let cornerRadius: CGFloat
    let text: String
    let textSize: CGFloat
    
//    let action: () -> Void
    
    var body: some View {
        Button(action: {
            print(text)
        }) {
            Text(text)
                .font(.custom("VarelaRound-Regular", size: textSize))
                .foregroundColor(Color("buttonTextColor"))
        }.frame(width: 100, height: 70)
            .background(Color("buttonColor"))
            .cornerRadius(cornerRadius)
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(cornerRadius: 50, text: "ButtonName", textSize: 25)
    }
}
