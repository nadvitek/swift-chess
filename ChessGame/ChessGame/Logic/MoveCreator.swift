//
//  MoveCreator.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 26.05.2023.
//

import Foundation

class MoveCreator {
    var board: [[Tile]] = []
    var lastMove: Move?
    
    func createMoves(for piece: Piece, board: [[Tile]], lastMove: Move?) -> [Move] {
        var moves: [Move] = []
        self.lastMove = lastMove
        self.board = board
        if let lastMove = lastMove {
            if lastMove.piece.alliance != piece.alliance {
                moves = createMovesForPiece(piece)
            }
        } else {
            if piece.alliance == .White {
                moves = createMovesForPiece(piece)
            }
        }
        return moves
    }
    
    func createMoves(for board: [[Tile]], of alliance: Alliance) -> [Move] {
        self.board = board
        var moves: [Move] = []
        for row in board {
            for tile in row {
                if let pieceOnTile = tile.piece {
                    guard pieceOnTile.alliance == alliance else {
                        continue
                    }
                    moves.append(contentsOf: createMovesForPiece(pieceOnTile))
                }
            }
        }
        return moves
    }
    
    func createMovesForPiece(_ piece: Piece) -> [Move] {
        switch piece.pieceType {
        case .Pawn:
            return createPawnMoves(for: piece)
        case .Knight:
            return createKnightMoves(for: piece)
        case .Bishop:
            return createBishopMoves(for: piece)
        case .Rook:
            return createRookMoves(for: piece)
        case .Queen:
            return createQueenMoves(for: piece)
        case .King:
            return createKingMoves(for: piece)
        }
    }
    
    func isOutOfBoard(x: Int, y: Int) -> Bool {
        return x > 7 || x < 0 || y > 7 || y < 0
    }
    
    func isMovePossible(x: Int, y: Int, alliance: Alliance) -> Bool {
        return !isOutOfBoard(x: x, y: y) && (board[y][x].isEmpty || board[y][x].piece!.isEnemyPiece(alliance: alliance))
    }
    
    func createPawnMoves(for pawn: Piece) -> [Move] {
        var moves: [Move] = []
        let pawnX = pawn.tile.x
        let pawnY = pawn.tile.y
        let parameter = pawn.alliance == .White ? 1 : -1
        

        let targetTile = board[pawnY + parameter][pawnX]
        if (targetTile.isEmpty) {
            moves.append(Move(from: pawn.tile, to: targetTile, with: pawn))
            if !pawn.hasMovedYet && board[pawnY + 2 * parameter][pawnX].isEmpty{
                moves.append(Move(from: pawn.tile, to: board[pawnY + 2 * parameter][pawnX], with: pawn))
            }
        }
    
        if (!isOutOfBoard(x: pawnX - 1, y: pawnY + parameter) && !board[pawnY + parameter][pawnX - 1].isEmpty && board[pawnY + parameter][pawnX - 1].piece!.isEnemyPiece(alliance: pawn.alliance)) {
            moves.append(Move(from: pawn.tile, to: board[pawnY + parameter][pawnX - 1], with: pawn))
        }
        
        if (!isOutOfBoard(x: pawnX + 1, y: pawnY + parameter) && !board[pawnY + parameter][pawnX + 1].isEmpty && board[pawnY + parameter][pawnX + 1].piece!.isEnemyPiece(alliance: pawn.alliance)) {
            moves.append(Move(from: pawn.tile, to: board[pawnY + parameter][pawnX + 1], with: pawn))
        }
        
        if let move = lastMove {
            if (move.piece.pieceType == .Pawn && move.isPawnTwoStepMove() && pawn.isNext(to: move.piece)) {
                moves.append(Move(from: pawn.tile, to: board[pawnY + parameter][move.piece.tile.x], with: pawn))
            }
        }
          
        
        return moves
    }
    
    func createKnightMoves(for knight: Piece) -> [Move]{
        var moves: [Move] = []
        let knightX = knight.tile.x
        let knightY = knight.tile.y
        
        
        if isMovePossible(x: knightX - 2, y: knightY + 1, alliance: knight.alliance){
            moves.append(Move(from: knight.tile, to: board[knightY + 1][knightX - 2], with: knight))
        }
        
        if isMovePossible(x: knightX - 1, y: knightY + 2, alliance: knight.alliance){
            moves.append(Move(from: knight.tile, to: board[knightY + 2][knightX - 1], with: knight))
        }
        
        if isMovePossible(x: knightX + 1, y: knightY + 2, alliance: knight.alliance){
            moves.append(Move(from: knight.tile, to: board[knightY + 2][knightX + 1], with: knight))
        }
        
        if isMovePossible(x: knightX + 2, y: knightY + 1, alliance: knight.alliance){
            moves.append(Move(from: knight.tile, to: board[knightY + 1][knightX + 2], with: knight))
        }
        
        if isMovePossible(x: knightX + 2, y: knightY - 1, alliance: knight.alliance){
            moves.append(Move(from: knight.tile, to: board[knightY - 1][knightX + 2], with: knight))
        }
        
        if isMovePossible(x: knightX + 1, y: knightY - 2, alliance: knight.alliance){
            moves.append(Move(from: knight.tile, to: board[knightY - 2][knightX + 1], with: knight))
        }
        
        if isMovePossible(x: knightX - 1, y: knightY - 2, alliance: knight.alliance){
            moves.append(Move(from: knight.tile, to: board[knightY - 2][knightX - 1], with: knight))
        }
        
        if isMovePossible(x: knightX - 2, y: knightY - 1, alliance: knight.alliance){
            moves.append(Move(from: knight.tile, to: board[knightY - 1][knightX - 2], with: knight))
        }
        
        return moves
    }
    
    func createBishopMoves(for bishop: Piece) -> [Move]{
        var moves: [Move] = []
        
        moves.append(contentsOf: getOneSidedCrossMoves(xParameter: -1, yParameter: 1, piece: bishop))
        moves.append(contentsOf: getOneSidedCrossMoves(xParameter: -1, yParameter: -1, piece: bishop))
        moves.append(contentsOf: getOneSidedCrossMoves(xParameter: 1, yParameter: 1, piece: bishop))
        moves.append(contentsOf: getOneSidedCrossMoves(xParameter: 1, yParameter: -1, piece: bishop))

        return moves
    }
    
    func getOneSidedCrossMoves(xParameter: Int, yParameter: Int, piece: Piece) -> [Move] {
        var moves: [Move] = []
        var newX = piece.tile.x + xParameter
        var newY = piece.tile.y + yParameter
        while (isMovePossible(x: newX, y: newY, alliance: piece.alliance)) {
            
            if (!board[newY][newX].isEmpty && board[newY][newX].piece!.isEnemyPiece(alliance: piece.alliance)) {
                moves.append(Move(from: piece.tile, to: board[newY][newX], with: piece))
                break;
            }
                
            moves.append(Move(from: piece.tile, to: board[newY][newX], with: piece))
            
            newX += xParameter
            newY += yParameter
        }
        return moves
    }
    
    func createRookMoves(for rook: Piece) -> [Move]{
        var moves: [Move] = []
        
        moves.append(contentsOf: getStraightMoves(piece: rook))
        
        return moves
    }
    
    func getStraightMoves(piece: Piece) -> [Move] {
        var moves: [Move] = []
        
        for y in (piece.tile.y + 1)..<8 {
            if (isMovePossible(x: piece.tile.x, y: y, alliance: piece.alliance)) {
                if (!board[y][piece.tile.x].isEmpty && board[y][piece.tile.x].piece!.isEnemyPiece(alliance: piece.alliance)) {
                    moves.append(Move(from: piece.tile, to: board[y][piece.tile.x], with: piece))
                    break;
                }
                
                moves.append(Move(from: piece.tile, to: board[y][piece.tile.x], with: piece))
            } else {
                break
            }
        }
        
        for y in (0..<piece.tile.y).reversed() {
            if (isMovePossible(x: piece.tile.x, y: y, alliance: piece.alliance)) {
                if (!board[y][piece.tile.x].isEmpty && board[y][piece.tile.x].piece!.isEnemyPiece(alliance: piece.alliance)) {
                    moves.append(Move(from: piece.tile, to: board[y][piece.tile.x], with: piece))
                    break;
                }
                
                moves.append(Move(from: piece.tile, to: board[y][piece.tile.x], with: piece))
            } else {
                break
            }
        }
        
        for x in (piece.tile.x + 1)..<8 {
            if (isMovePossible(x: x, y: piece.tile.y, alliance: piece.alliance)) {
                if (!board[piece.tile.y][x].isEmpty && board[piece.tile.y][x].piece!.isEnemyPiece(alliance: piece.alliance)) {
                    moves.append(Move(from: piece.tile, to: board[piece.tile.y][x], with: piece))
                    break;
                }
                
                moves.append(Move(from: piece.tile, to: board[piece.tile.y][x], with: piece))
            } else {
                break
            }
        }
        
        for x in (0..<piece.tile.x).reversed() {
            if (isMovePossible(x: x, y: piece.tile.y, alliance: piece.alliance)) {
                if (!board[piece.tile.y][x].isEmpty && board[piece.tile.y][x].piece!.isEnemyPiece(alliance: piece.alliance)) {
                    moves.append(Move(from: piece.tile, to: board[piece.tile.y][x], with: piece))
                    break;
                }
                
                moves.append(Move(from: piece.tile, to: board[piece.tile.y][x], with: piece))
            } else {
                break
                
            }
        }
        
        
        return moves
    }
    
    func createQueenMoves(for queen: Piece) -> [Move]{
        var moves: [Move] = []
        
        moves.append(contentsOf: getOneSidedCrossMoves(xParameter: -1, yParameter: 1, piece: queen))
        moves.append(contentsOf: getOneSidedCrossMoves(xParameter: -1, yParameter: -1, piece: queen))
        moves.append(contentsOf: getOneSidedCrossMoves(xParameter: 1, yParameter: 1, piece: queen))
        moves.append(contentsOf: getOneSidedCrossMoves(xParameter: 1, yParameter: -1, piece: queen))

        moves.append(contentsOf: getStraightMoves(piece: queen))
        
        return moves
    }
    
    func createKingMoves(for king: Piece) -> [Move]{
        var moves: [Move] = []
        
        if (isMovePossible(x: king.tile.x + 1, y: king.tile.y + 1, alliance: king.alliance)) {
            moves.append(Move(from: king.tile, to: board[king.tile.y + 1][king.tile.x + 1], with: king))
        }
        
        if (isMovePossible(x: king.tile.x + 1, y: king.tile.y, alliance: king.alliance)) {
            moves.append(Move(from: king.tile, to: board[king.tile.y][king.tile.x + 1], with: king))
        }
        
        if (isMovePossible(x: king.tile.x + 1, y: king.tile.y - 1, alliance: king.alliance)) {
            moves.append(Move(from: king.tile, to: board[king.tile.y - 1][king.tile.x + 1], with: king))
        }
        
        if (isMovePossible(x: king.tile.x, y: king.tile.y - 1, alliance: king.alliance)) {
            moves.append(Move(from: king.tile, to: board[king.tile.y - 1][king.tile.x], with: king))
        }
        
        if (isMovePossible(x: king.tile.x - 1, y: king.tile.y - 1, alliance: king.alliance)) {
            moves.append(Move(from: king.tile, to: board[king.tile.y - 1][king.tile.x - 1], with: king))
        }
        
        if (isMovePossible(x: king.tile.x - 1, y: king.tile.y, alliance: king.alliance)) {
            moves.append(Move(from: king.tile, to: board[king.tile.y][king.tile.x - 1], with: king))
        }
        
        if (isMovePossible(x: king.tile.x - 1, y: king.tile.y + 1, alliance: king.alliance)) {
            moves.append(Move(from: king.tile, to: board[king.tile.y + 1][king.tile.x - 1], with: king))
        }
        
        if (isMovePossible(x: king.tile.x, y: king.tile.y + 1, alliance: king.alliance)) {
            moves.append(Move(from: king.tile, to: board[king.tile.y + 1][king.tile.x], with: king))
        }
        
        if (!king.hasMovedYet && board[king.tile.y][king.tile.x + 2].isEmpty && board[king.tile.y][king.tile.x + 1].isEmpty) {
            if let rook = board[king.tile.y][7].piece {
                if !rook.hasMovedYet && !rook.isEnemyPiece(alliance: king.alliance) && rook.pieceType == .Rook {
                    moves.append(Move(from: king.tile, to: board[king.tile.y][king.tile.x + 2], with: king))
                }
            }
        }
        
        
        if (!king.hasMovedYet && board[king.tile.y][king.tile.x - 2].isEmpty && board[king.tile.y][king.tile.x -  1].isEmpty && board[king.tile.y][king.tile.x -  3].isEmpty) {
            if let rook = board[king.tile.y][0].piece {
                if !rook.hasMovedYet && !rook.isEnemyPiece(alliance: king.alliance) && rook.pieceType == .Rook {
                    moves.append(Move(from: king.tile, to: board[king.tile.y][king.tile.x - 2], with: king))
                }
            }
        }
        
        
        
        return moves
    }
    
    
    
}
