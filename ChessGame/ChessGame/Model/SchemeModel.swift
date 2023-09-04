//
//  SchemeModel.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 04.09.2023.
//

import Foundation


struct SchemeModel: Codable {
    var colorScheme: String
    
    init(colorScheme: String) {
        self.colorScheme = colorScheme
    }
}
