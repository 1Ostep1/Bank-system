//
//  SalaryAccount.swift
//  iBank
//
//  Created by Iusupov Ramazan on 2/11/22.
//

import Foundation

class SalaryAccount: BankAccount {
    var employer: String
    var monthlySalary: Double
    
    init(accNo: String, accBalance: Double, employer: String, monthlySalary: Double) {
        self.employer = employer
        self.monthlySalary = monthlySalary
        
        super.init(accNo: accNo, accBalance: accBalance)
    }
    
    private enum CodingKeys: String, CodingKey {
        case employer
        case monthlySalary
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(employer, forKey: .employer)
        try container.encode(monthlySalary, forKey: .monthlySalary)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        employer = try container.decode(String.self, forKey: .employer)
        monthlySalary = try container.decode(Double.self, forKey: .monthlySalary)
        try super.init(from: decoder)
    }
}
