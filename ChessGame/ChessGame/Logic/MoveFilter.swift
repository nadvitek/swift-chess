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
            self.board = copyBoard(board: board)
            printBoard()
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
        
        if (move.isCastleMove()) {
            let boardBeforeMove: [[Tile]] = copyBoard(board: board!)
            let sourceX = move.sourceTile.x
            let sourceY = move.sourceTile.y
            let destX = move.destinationTile.x + (move.isSmallCastleMove() ? -1 : 1)
            let destY = move.destinationTile.y
            let destTile = board?[destY][destX]
            let sourceTile = board?[sourceY][sourceX]
            sourceTile!.piece?.move(to: destTile!)
            sourceTile!.piece = nil
            
            if (isKingInCheck(move)) {
                return false
            }
            self.board = boardBeforeMove
        }
        
        
        
        
        let sourceX = move.sourceTile.x
        let sourceY = move.sourceTile.y
        let destX = move.destinationTile.x
        let destY = move.destinationTile.y
        let destTile = board?[destY][destX]
        let sourceTile = board?[sourceY][sourceX]
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
                        let moves = moveCreator.createMoves(for: pieceOnTile, board: board!, lastMove: move)
                        for anotherMove in moves {
                            if let targetPiece = anotherMove.destinationTile.piece {
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
    
    func copyBoard(board: [[Tile]]) -> [[Tile]] {
        var newBoard: [[Tile]] = []
        for y in 0..<8 {
            var row: [Tile] = []
            for x in 0..<8 {
                row.append(board[y][x].copy() as! Tile)
            }
            newBoard.append(row)
        }
        return newBoard
    }
    
    func printBoard() {
        for y in 0..<8 {
            for x in 0..<8 {
                if let piece = board?[y][x].piece {
                    print("\(piece.pieceType.sign)", terminator: "")
                } else {
                    print(" ", terminator: "")
                }
            }
            print(" ")
        }
        print(" ")
        print(" ")
        print(" ")
    }
}
