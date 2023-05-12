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
    let size: CGFloat
//    let action: () -> Void
    
    var body: some View {
        Button(action: {
            //action()
        }) {
            Text(text)
                .font(.custom("VarelaRound-Regular", size: size))
                .foregroundColor(Color("buttonTextColor"))
                .padding()
                .background(Color("buttonColor"))
                .cornerRadius(cornerRadius)
        }
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(cornerRadius: 30, text: "ButtonName", size: 25)
    }
}
