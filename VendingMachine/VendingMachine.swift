//
//  VendingMachine.swift
//  VendingMachine
//
//  Created by Henry Moran on 11/21/17.
//  Copyright © 2017 Treehouse Island, Inc. All rights reserved.
//

import Foundation
import UIKit

// created the items that will go into the vending machine
// instead of using strings we are using an enum to eliminate
// typing errors that comes with using "string" variables
enum VendingSelection: String {
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
    
    func icon() -> UIImage {
         //self in this case refers to the members of the VendingSelection Enum
        if let image = UIImage(named: self.rawValue) {
            return image
        } else {
            return #imageLiteral(resourceName: "default")
        }
    }
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
    var inventory: [VendingSelection: VendingItem] { get set }
    var amountDeposited: Double { get set }
    
    init(inventory: [VendingSelection: VendingItem])
    func vend(selection: VendingSelection, quantity: Int) throws
    func deposit(_ amount: Double)
    func item(forSelection selection: VendingSelection) -> VendingItem?
}

struct Item: VendingItem {
    let price: Double
    var quantity: Int
}

enum InventoryError: Error {
    case invalidResources
    case conversionFailure
    case invalidSelection
}

class PlistConverter {
    // static is a type method
    static func dictionary(fromFile name: String, ofType type: String) throws -> [String: AnyObject] {
        guard let path = Bundle.main.path(forResource: name, ofType: type) else {
            throw InventoryError.invalidResources
        }
        guard let dictionary = NSDictionary(contentsOfFile: path) as? [String: AnyObject] else {
            throw InventoryError.conversionFailure
        }
        
        return dictionary
        
    }
}

class InventoryUnarchiver {
    static func vendingInventory(fromDictionary dictionary: [String: AnyObject]) throws -> [VendingSelection: VendingItem] {
        var inventory: [VendingSelection: VendingItem] = [:]
        
        for (key, value) in dictionary {
            if let itemDictionary = value as? [String: Any], let price = itemDictionary["price"] as? Double, let quantity = itemDictionary["quantity"] as? Int {
                let item = Item(price: price, quantity: quantity)
                
                guard let selection = VendingSelection(rawValue: key) else {
                    throw InventoryError.invalidSelection
                }
                
                inventory.updateValue(item, forKey: selection)
            }
        }
        return inventory
    }
}

enum VendingMachineError: Error {
    case invalidSelection
    case outOfStock
    case insufficientFunds(required: Double)
}

// Provide implentation for the vending maching from the protocols we created above
class FoodVendingMachine: VendingMachine {
    let selection: [VendingSelection] = [.soda, .dietSoda, .wrap, .chips, .cookie, .sandwich,. candyBar, .popTart, .water, .fruitJuice, .sportsDrink, .gum]
    
    var inventory: [VendingSelection : VendingItem]
    var amountDeposited: Double = 10.0
    
    required init(inventory: [VendingSelection : VendingItem]) {
        self.inventory = inventory
    }
    
    func vend(selection: VendingSelection, quantity: Int) throws {
        guard var item = inventory[selection] else {
            throw VendingMachineError.invalidSelection
        }
        guard item.quantity >= quantity else {
            throw VendingMachineError.outOfStock
        }
        
        let totalPrice = item.price * Double(quantity)
        
        if amountDeposited >= totalPrice {
            amountDeposited -= totalPrice
            
            item.quantity -= quantity
            
            inventory.updateValue(item, forKey: selection)
        } else {
            let amountRequired = totalPrice - amountDeposited
            throw VendingMachineError.insufficientFunds(required: amountRequired)
        }
    }
    
    func deposit(_ amount: Double) {
        
    }
    
    func item(forSelection selection: VendingSelection) -> VendingItem? {
        return inventory[selection]
    }
}
































