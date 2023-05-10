//
//  ContentView.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 10.05.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10), style: .circular).foregroundColor(.brown)
                Button("Play Game") {
                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                }.foregroundColor(.black)
            }
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
