//
//  Customers.swift
//  iBank
//
//  Created by Iusupov Ramazan on 2/11/22.
//

import Foundation

class Customers: Codable {
    var customers: [CustomerDetails]
    
    init(custs: [CustomerDetails]) {
        self.customers = custs
    }
}

class CustomerDetails: Codable {
    var name: String
    var contactNo: String
    var address: String
    var password: String
    var gender: String
    
    var accounts: Accounts?
    
    init(name: String, contactNo: String, address: String, password: String, gender: String) {
        self.name = name
        self.contactNo = contactNo
        self.address = address
        self.password = password
        self.gender = gender
    }
    
    func addBankAccounts(accs: Accounts) {
        accounts = accs
    }
}

enum Gender {
    case male
    case female
}
