//
//  TileViewModel.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 23.05.2023.
//

import Foundation


extension TileView {
    @MainActor class TileViewModel: ObservableObject {
        @Published var x: Int?
        @Published var y: Int?
        
    }
}

