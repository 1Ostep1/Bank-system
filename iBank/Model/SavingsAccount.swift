//
//  SavingsAccount.swift
//  iBank
//
//  Created by Iusupov Ramazan on 2/11/22.
//

import Foundation

class SavingsAccount: BankAccount {
    var minBalance: Double
    var interestRate: Double
    
    init(accNo: String, accBalance: Double, minBal: Double, intRate: Double) {
        self.minBalance = minBal
        self.interestRate = intRate
        super.init(accNo: accNo, accBalance: accBalance)
    }
    
    private enum CodingKeys: String, CodingKey {
        case minBalance
        case interestRate
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(minBalance, forKey: .minBalance)
        try container.encode(interestRate, forKey: .interestRate)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        minBalance = try container.decode(Double.self, forKey: .minBalance)
        interestRate = try container.decode(Double.self, forKey: .interestRate)
        try super.init(from: decoder)
    }
}
