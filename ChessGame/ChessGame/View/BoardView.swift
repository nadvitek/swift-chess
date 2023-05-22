//
//  BoardView.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 22.05.2023.
//

import SwiftUI

struct BoardView: View {
    let letters = ["A", "B", "C", "D", "E", "F", "G", "H"]
    
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                let size = geo.size.width * 0.9
                
                Rectangle()
                    .frame(width: size, height: size)
                .foregroundColor(Color("boardColor"))
                
                ForEach(0..<8, id: \.self) { x in
                    ForEach(0..<8, id: \.self) { y in
                        TileView(x: x, y: y)
                    }
                }
                
                VStack {
                    let offset = size * 0.053
                    ForEach(0..<8) { i in
                        Text(String(8 - i))
                            .font(.headline)
                            .foregroundColor(.white)
                            .offset(y: offset * Double(i))
                    }
                }.position(x: size * 0.085, y: size * 0.89)
                
                HStack {
                    let offset = size * 0.053
                    ForEach(0..<8) { i in
                        Text(letters[i])
                            .font(.headline)
                            .foregroundColor(.white)
                            .offset(x: offset * Double(i))
                    }
                    
                }.position(x: size * 0.37, y: size * 1.54)
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}

struct TileView: View {
    let x: Int;
    let y: Int;
    
    var body: some View {
        GeometryReader { geo in
            let size = geo.size.width * 0.099
            let positionX = geo.size.width * 0.153 + size * Double(x)
            let positionY = geo.size.height * 0.6794 - size * Double(y)
            Button(action: {
                
            }){
            }
                .frame(width: size, height: size)
                .background((x + y) % 2 == 0 ? Color("darkTileColor") : Color("lightTileColor"))
                .position(x: positionX, y: positionY)
                
        }
    }
}



struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
    }
}
