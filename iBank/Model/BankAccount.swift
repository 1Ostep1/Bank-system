//
//  BankAccount.swift
//  iBank
//
//  Created by Iusupov Ramazan on 2/11/22.
//

import Foundation

enum AccountTypes {
    case savingAcc
    case salaryAcc
    case fdAcc
}

class Accounts: Codable {
    var salaryAcc: SalaryAccount?
    var savingsAcc: SavingsAccount?
    var fixedDepositAcc: FixedDepositAccount?
    
    init(salAcc: SalaryAccount? = nil, savAcc: SavingsAccount? = nil, fixAcc: FixedDepositAccount? = nil) {
        self.salaryAcc = salAcc
        self.savingsAcc = savAcc
        self.fixedDepositAcc = fixAcc
    }
}

class BankAccount: Codable {
    var accountNo: String
    var accountBalance: Double
    
    init(accNo: String, accBalance: Double) {
        self.accountNo = accNo
        self.accountBalance = accBalance
    }
    
    // way to encode manually due to inheritance
    private enum CodingKeys: String, CodingKey {
        case accountNo
        case accountBalance
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accountNo, forKey: .accountNo)
        try container.encode(accountBalance, forKey: .accountBalance)
    }
    
    // Functions for transactions
    func addBalance(amountToAdd: Double) -> Double {
        accountBalance += amountToAdd
        return accountBalance
    }
    
    func deductBalance(amountToDeduct: Double) -> Double {
        accountBalance -= amountToDeduct
        return accountBalance
    }
}
