//
//  Alerts.swift
//  TicTac
//
//  Created by user217110 on 5/20/22.
//

import SwiftUI

struct AlertItem: Identifiable{
    let id = UUID()
    var title: Text
    var message: Text
    var ButtonTitle: Text
    
}
struct AlertContext {
    static let humanWin = AlertItem(title: Text("You Win!!"), message: Text("Congratulations!!"), ButtonTitle: Text("Winn!"))
   static let ComputerWin = AlertItem(title: Text("Computer Win!!"), message: Text("Try Again!!"), ButtonTitle: Text("Lost!"))
   static let Draw = AlertItem(title: Text("Draw!!"), message: Text("Best of luck next time"), ButtonTitle: Text("BadLuck"))
}
