//
//  ContentView.swift
//  TicTac
//
//  Created by user217110 on 5/20/22.
//

import SwiftUI


struct ContentView: View {
    let columns: [GridItem] = [GridItem(.flexible()),
                       GridItem(.flexible()),
                       GridItem(.flexible()),]
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var isGameBoardDisabled = false
    @State private var alertItem: AlertItem?
    
    var body: some View {
         GeometryReader{geometry in
        VStack{
            Spacer()
            Text("Tic Tac Toe").font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/).fontWeight(/*@START_MENU_TOKEN@*/.heavy/*@END_MENU_TOKEN@*/).foregroundColor(Color.red).padding(.all, 20.0)
            LazyVGrid(columns: columns, spacing: 5){
                ForEach(0..<9){i in
                    ZStack{
                        Circle()
                            .foregroundColor(Color(hue: 0.001, saturation: 0.728, brightness: 0.656))
                          
                            .frame(width: geometry.size.width / 3 - 15,
                                   height: geometry.size.width / 3 - 15)
                        Image(systemName: moves[i]?.indicator ?? " ")
                            .frame(width: 50, height: 50)
                    }
                    .onTapGesture {
                        if isOccupied(in: moves, forIndex: i){ return}
                        moves[i] = Move(player:.human , boardIndex: i)
                        
                        if checkWinCondition(for: .human, in: moves){
                            alertItem = AlertContext.humanWin
                            return
                        }
                        if checkDraw(in: moves)
                        {
                            alertItem = AlertContext.Draw
                            return
                        }
                        isGameBoardDisabled = true

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
                            let computerPosition = determinesComputerMovesAdvanced(in: moves)
                            moves[computerPosition] = Move(player: .computer , boardIndex: computerPosition)
                            isGameBoardDisabled = false
                            if checkWinCondition(for: .computer, in: moves){
                                alertItem = AlertContext.ComputerWin
                                return
                            }
                            if checkDraw(in: moves)
                            {
                                alertItem = AlertContext.Draw
                                return
                            }
                           
                           
                        }
                        
                        }
                    }
                }
            Spacer()
            }
            
        }
        .disabled(isGameBoardDisabled)
        .padding()
        .background(Color(hue: 0.292, saturation: 0.076, brightness: 0.82, opacity: 0.628))
        .alert(item: $alertItem, content: { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: .default(alertItem.ButtonTitle, action: {resetGame()}))
                  })
    }

    func isOccupied(in moves: [Move?] , forIndex index: Int) -> Bool {
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
    func determinesComputerMovesAdvanced(in moves: [Move?])-> Int {
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5],[6,7,8],[0,3,6], [1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        let computerMoves = moves.compactMap { $0 }.filter{ $0.player == .computer}
        let computerPosition = Set(computerMoves.map{ $0.boardIndex })
          
        for pattern in winPatterns{
            let winPositions = pattern.subtracting(computerPosition)
            
            if winPositions.count == 1{
                let isAvailible = !isOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailible {return winPositions.first!}
            }
        }
        
        let humanMoves = moves.compactMap { $0 }.filter{ $0.player == .human}
        let humanPosition = Set(humanMoves.map{ $0.boardIndex })
          
        
        for pattern in winPatterns{
            let winPositions = pattern.subtracting(humanPosition)
            
            if winPositions.count == 1{
                let isAvailible = !isOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailible {return winPositions.first!}
            }
        }
        
        
        var moveposition = Int.random(in: 0..<9)
        while isOccupied(in: moves, forIndex: moveposition){
        moveposition = Int.random(in: 0..<9)
        }
        return moveposition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5],[6,7,8],[0,3,6], [1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        
        let playerMoves = moves.compactMap { $0 }.filter{$0.player == player}
        let playerPosition = Set(playerMoves.map{$0.boardIndex})
        
        for pattern in winPatterns where pattern.isSubset(of: playerPosition){
            return true
        }
        
        return false
    }
    func checkDraw(in moves: [Move?]) -> Bool{
        return moves.compactMap{ $0 }.count == 9
    }
               func resetGame(){
        moves = Array(repeating: nil, count: 9)
        }
    
}

enum Player {
case human, computer
}
struct Move{
    let player: Player
    let boardIndex: Int
    var indicator: String{
        return player == .human ? "circle" : "xmark"
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
