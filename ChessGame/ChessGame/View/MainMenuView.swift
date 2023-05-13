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
                HStack {
                    Image(systemName: "questionmark.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Spacer()
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                }.padding()
                    .offset(y: -300)
                HStack {
                    ButtonView(cornerRadius: 30, text: "Single Player", textSize: 18)
                    ButtonView(cornerRadius: 30, text: "Multi Player", textSize: 18)
                    ButtonView(cornerRadius: 30, text: "Custom Board", textSize: 18)
                }
                VStack {
                    
                }
            }
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
