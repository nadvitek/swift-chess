//
//  MainMenuView.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 10.05.2023.
//

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill()
                .ignoresSafeArea()
                .foregroundColor(Color("backgroundColor"))
            VStack {
                ButtonView(cornerRadius: 30, text: "Single Player", size: 25)
                ButtonView(cornerRadius: 30, text: "Multi Player", size: 25)
                ButtonView(cornerRadius: 30, text: "Custom Board", size: 25)
            }
            .padding()
            .ignoresSafeArea()
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
