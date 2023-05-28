//
//  MoveFilter.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 27.05.2023.
//

import Foundation

class MoveFilter {
    var board: [[Tile]]?
    let moveCreator: MoveCreator
    
    init(_ moveCreator: MoveCreator){
        self.moveCreator = moveCreator
    }
    func filter(_ moves: [Move], board: [[Tile]]) -> [Move]{
        var filteredMoves: [Move] = []
        for move in moves {
            copyBoard(board: board)
            if isMoveValid(move) {
                filteredMoves.append(move)
            }
        }
        return filteredMoves
    }
    
    func isMoveValid(_ move: Move) -> Bool {
        if (move.isEnPassanteMove()) {
            board?[move.destinationTile.y + (move.piece.alliance == .White ? -1 : 1)][move.destinationTile.x].piece = nil
        }
        var sourceX = move.sourceTile.x
        var sourceY = move.sourceTile.y
        var destX = move.destinationTile.x
        var destY = move.destinationTile.y
        var destTile = board?[destY][destX]
        var sourceTile = board?[sourceY][sourceX]
        sourceTile!.piece?.move(to: destTile!)
        sourceTile!.piece = nil
        
        if (isKingInCheck(move)) {
            return false
        }
        
        return true
    }
    
    func isKingInCheck(_ move: Move) -> Bool {
        for y in 0..<8 {
            for x in 0..<8 {
                let tile = board![y][x]
                if let pieceOnTile = tile.piece {
                    if (pieceOnTile.alliance != move.piece.alliance) {
                        let moves = moveCreator.createMovesForPiece(pieceOnTile)
                        for move in moves {
                            if let targetPiece = move.destinationTile.piece {
                                if targetPiece.pieceType == .King && targetPiece.alliance == move.piece.alliance {
                                    return true
                                }
                            }
                        }
                    }
                }
            }
        }
        return false
    }
    
    func checkAppeared() -> Bool {
        return false
    }
    
    func copyBoard(board: [[Tile]]) {
        var newBoard: [[Tile]] = []
        for y in 0..<8 {
            var row: [Tile] = []
            for x in 0..<8 {
                row.append(board[y][x].copy() as! Tile)
            }
            newBoard.append(row)
        }
        self.board = newBoard
    }
}
