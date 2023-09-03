//
//  ButtonView.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 12.05.2023.
//

import SwiftUI

struct ButtonView: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        RoundedRectangle(cornerRadius: 50)
                .foregroundColor(.button)
                .frame(width: 100, height: 70)
                .overlay {
                    Text(text)
                        .foregroundColor(.black)
                        .font(.getFont(of: 22))
                        .multilineTextAlignment(.center)
                }
                .onTapGesture(perform: action)
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(text: "Button Name", action: {})
    }
}
