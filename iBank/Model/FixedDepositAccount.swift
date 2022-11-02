//
//  FixedDepositAccount.swift
//  iBank
//
//  Created by Iusupov Ramazan on 2/11/22.
//

import Foundation

class FixedDepositAccount: BankAccount {
    var termDuration: Int
    var interestRate: Double
    
    init(accNo: String, accBalance: Double, termDur: Int, intRate: Double) {
        self.termDuration = termDur
        self.interestRate = intRate
        
        super.init(accNo: accNo, accBalance: accBalance)
    }
    
    private enum CodingKeys: String, CodingKey {
        case termDuration
        case interestRate
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(termDuration, forKey: .termDuration)
        try container.encode(interestRate, forKey: .interestRate)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        termDuration = try container.decode(Int.self, forKey: .termDuration)
        interestRate = try container.decode(Double.self, forKey: .interestRate)
        try super.init(from: decoder)
    }
}

