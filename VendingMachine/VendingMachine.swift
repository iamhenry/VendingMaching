//
//  VendingMachine.swift
//  VendingMachine
//
//  Created by Henry Moran on 11/21/17.
//  Copyright © 2017 Treehouse Island, Inc. All rights reserved.
//

import Foundation

// created the items that will go into the vending machine
// instead of using strings we are using an enum to eliminate
// typing errors that comes with using "string" variables
enum VendingSelection {
    case soda
    case dietSoda
    case chips
    case cookie
    case sandwich
    case wrap
    case candyBar
    case popTart
    case water
    case fruitJuice
    case sportsDrink
    case gum
}

protocol VendingItem {
    var price: Double { get }
    var quantity: Int { get set }
}

// Created the vending machine so that it's flexible for the future
// if we want to create a vending machine that sells electronic, these protocols
// are flexible enough to do that
protocol VendingMachine {
    var selection: [VendingSelection] { get }
    var invetory: [VendingSelection: VendingItem] { get set }
    var amountDeposited: Double { get set }
    
    init(inventory: [VendingSelection: VendingItem])
    func vend(_ quantity: Int, _ selection: VendingSelection) throws
    func deposit(_ amount: Double)
}
