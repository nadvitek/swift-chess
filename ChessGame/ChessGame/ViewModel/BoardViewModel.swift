//
//  BoardViewModel.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 24.05.2023.
//

import Foundation

@MainActor class BoardViewModel: ObservableObject {
    @Published var board: [[Tile]] = []
    var lastMove: Move?
    var markedTiles: [Tile] = []
    var showedMoves: [Move] = []
    var whiteMoves: [Move] = []
    var blackMoves: [Move] = []
    let moveCreator: MoveCreator
    let moveFilter: MoveFilter
    var gameOver = false
    @Published var processingPromotion = false
    var promotedPiece: Piece? {
        willSet(piece) {
            if (piece == nil) {
                processingPromotion = false
                calculateMoves()
            } else {
                processingPromotion = true
            }
        }
    }
    
    init() {
        moveCreator = MoveCreator()
        moveFilter = MoveFilter(moveCreator)
        for y in 0..<8 {
            var row: [Tile] = []
            for x in 0..<8 {
                row.append(addTile(x: x, y: y))
            }
            board.append(row)
        }
        calculateMoves()
    }
    
    func resetSelection() {
        for tile in markedTiles {
            tile.isTargetTile = false
        }
        markedTiles.removeAll()
        showedMoves.removeAll()
    }
    
    func getMove(destinationTile: Tile) -> Move? {
        for move in showedMoves {
            if move.destinationTile.compareTo(other: destinationTile) {
                return move
            }
        }
        return nil
    }
    
    func getOnTurnPlayersMoves() -> [Move] {
        if let lastPlayedMove = lastMove {
            return lastPlayedMove.piece.alliance == .White ? blackMoves : whiteMoves
        }
        return whiteMoves
    }
    
    func calculateMoves() {
        whiteMoves.removeAll()
        blackMoves.removeAll()
        for y in 0..<8 {
            for x in 0..<8 {
                createMovesForTile(x: x, y: y)
            }
        }
        filterMoves()
        if getOnTurnPlayersMoves().isEmpty {
            gameOver = true
        }
    }
    
    func createMovesForTile(x: Int, y: Int) {
        if let piece = board[y][x].piece {
            if let lastMove = lastMove {
                if (piece.alliance == lastMove.piece.alliance) {
                    return
                }
            } else {
                if (piece.alliance != .White) {
                    return
                }
            }
            if (piece.alliance == .White) {
                whiteMoves.append(contentsOf: moveCreator.createMoves(for: piece, board: board, lastMove: lastMove))
            } else {
                blackMoves.append(contentsOf: moveCreator.createMoves(for: piece, board: board, lastMove: lastMove))
            }
        }
    }
    
    func filterMoves() {
        if let lastPlayedMove = lastMove {
            if (lastPlayedMove.piece.alliance == .Black) {
                whiteMoves = moveFilter.filter(whiteMoves, board: board)
            } else {
                blackMoves = moveFilter.filter(blackMoves, board: board)
            }
        }
    }
    
    func processTile(x: Int, y: Int, onTurn: Alliance) -> Bool {
        if (processingPromotion) {
            return false
        }
        
        let selectedTile = board[y][x]
        if (selectedTile.isTargetTile) {
            let move = getMove(destinationTile: selectedTile)!
            lastMove = move
            if (move.isEnPassanteMove()) {
                board[move.destinationTile.y + (move.piece.alliance == .White ? -1 : 1)][move.destinationTile.x].piece = nil
            }
            
            if (move.isCastleMove()) {
                let rookTile = board[move.destinationTile.y][move.isSmallCastleMove() ? 7 : 0]
                rookTile.piece?.move(to: board[move.destinationTile.y][move.isSmallCastleMove() ? 5 : 3])
                rookTile.piece = nil
            }
            
            move.piece.move(to: selectedTile)
            move.sourceTile.piece = nil
            resetSelection()
            if (move.isPromotionMove()) {
                promotedPiece = move.piece
            } else {
                calculateMoves()
            }
            return true
        } else {
            resetSelection()
            if let pieceOnTile = selectedTile.piece {
                if pieceOnTile.alliance != onTurn {
                    return false
                }
                let moves = getMovesOfPiece(pieceOnTile)
                processMoves(moves: moves)
            }
        }
        return false
    }
    
    func getMovesOfPiece(_ piece: Piece) -> [Move] {
        var moves:[Move] = []
        var setOfMoves: [Move]
        if piece.alliance == .White {
            setOfMoves = whiteMoves
        } else {
            setOfMoves = blackMoves
        }
        
        for move in setOfMoves {
            if move.piece === piece {
                moves.append(move)
            }
        }
        
        return moves
    }
    
    func processMoves(moves: [Move]) {
        for move in moves {
            let targetTile = move.destinationTile
            markedTiles.append(targetTile)
            
            targetTile.isTargetTile = true
        }
        
        showedMoves.append(contentsOf: moves)
    }
}


//MARK: - Creational Functions
extension BoardViewModel {
    func addTile(x: Int, y: Int) -> Tile {
        let tile = Tile(x: x, y: y)
        
        if let piece = addPieceToStartingPosition(tile: tile) {
            tile.piece = piece
        }
        
        return tile
    }
    
    func addPieceToStartingPosition(tile: Tile) -> Piece? {
        if let pawn = addPawns(tile: tile) {
            return pawn
        } else if let knight = addTwoTilePieces(of: .Knight, x1: 1, x2: 6, tile: tile) {
            return knight
        } else if let bishop = addTwoTilePieces(of: .Bishop, x1: 2, x2: 5, tile: tile) {
            return bishop
        } else if let rook = addTwoTilePieces(of: .Rook, x1: 0, x2: 7, tile: tile) {
            return rook
        } else if let ruler = addKingAndQueen(tile: tile) {
            return ruler
        }
        return nil
    }
    
    func addTwoTilePieces(of pieceType: PieceType, x1: Int, x2: Int, tile: Tile) -> Piece? {
        let isPiecesColumn = (tile.x == x1 || tile.x == x2)
        if tile.y == 0 && isPiecesColumn {
            return Piece(on: tile, being: pieceType, ofColor: .White)
        } else if tile.y == 7 && isPiecesColumn {
            return Piece(on: tile, being: pieceType, ofColor: .Black)
        }
        return nil
    }
    
    func addPawns(tile: Tile) -> Piece? {
        if tile.y == 1 {
            return Piece(on: tile, being: .Pawn, ofColor: .White)
        } else if tile.y == 6 {
            return Piece(on: tile, being: .Pawn, ofColor: .Black)
        }
        return nil
    }
    
    func addKingAndQueen(tile: Tile) -> Piece? {
        if tile.x == 3 {
            return addQueen(tile: tile)
        } else if tile.x == 4 {
            return addKing(tile: tile)
        }
        return nil
    }
    
    func addKing(tile: Tile) -> Piece? {
        if tile.y == 0 {
            return Piece(on: tile, being: .King, ofColor: .White)
        } else if tile.y == 7 {
            return Piece(on: tile, being: .King, ofColor: .Black)
        }
        return nil
    }
    
    func addQueen(tile: Tile) -> Piece? {
        if tile.y == 0 {
            return Piece(on: tile, being: .Queen, ofColor: .White)
        } else if tile.y == 7 {
            return Piece(on: tile, being: .Queen, ofColor: .Black)
        }
        return nil
    }
}
