//
//  ViewProperties.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 13.08.2023.
//

import SwiftUI

extension Font {
    static func getFont(of size: CGFloat) -> Font {
        return Font.custom("VarelaRound-Regular", size: size)
    }
}

extension Color {
    static let bg = Color("backgroundColor")
    static let text = Color("textColor")
    static let button = Color("buttonColor")
    static let apple = Color("appleButton")
}
