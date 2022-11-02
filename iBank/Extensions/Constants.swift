//
//  Constants.swift
//  iBank
//
//  Created by Keval on 3/24/21.
//

import Foundation

class Constants {
    static let transactionMenu = "Enter the number associated with the action, to perform that action.\n1 - Display current balance\n2 - Deposit money\n3 - Draw money\n4 - Transfer money to other bank account\n5 - Pay Electricity bill\n6 - Pay Credit card bill\n7 - Add new bank account\n8 - Show or Change customer details\n0 - Logout (go back to previous menu)"
    
    
    static var customers: Customers?
    static var loggedInCustomer: CustomerDetails?
    static var savedData: (cust: Customers?, isFirstTime: Bool) = (nil, true)

    // Constants
    static let savingMinBal = Double(100)
    static let savingIntRate = Double(6)
    static let fdIntRate = Double(9)
    static var lastAccountNumber = 0

    static func updateData() {
        var jsonStr = ""
        for i in 0..<customers!.customers.count {
            if customers!.customers[i].name == loggedInCustomer!.name {
                customers!.customers[i] = loggedInCustomer!
            }
        }
        
        jsonStr = getJsonString(of: customers!)
        
        saveJsonFile(of: jsonStr)
    }

    // for development purpose
    static func showJson() {
        let json = getJsonString(of: customers!)
        print(json)
    }

}
