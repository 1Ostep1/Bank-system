//
//  AuthorizationService.swift
//  iBank
//
//  Created by Iusupov Ramazan on 2/11/22.
//

import Foundation

class AuthorizationService {
    static let shared = AuthorizationService()
    
    private init() { }
    
    
    func tryLogin(name: String, pass: String) -> CustomerDetails? {
        if let custs = Constants.customers?.customers {
            for cust in custs {
                if cust.name.lowercased() == name.lowercased(),
                   cust.password.lowercased() == pass.lowercased() {
                    // code to login
                    return cust
                }
            }
        }
        return nil
    }
    
    func generateAccountNumber() -> String {
        var accNo = 0
        var lastAccNo = Constants.lastAccountNumber
        let SavedData = getSavedData()
        if SavedData.isFirstTime {
            accNo = Int(String(format: "%03d", 1))!
        }
        else {
            if let custs = SavedData.cust {
                for cust in custs.customers {
                    
                    if let fd = cust.accounts!.fixedDepositAcc {
                        if Int(fd.accountNo)! > lastAccNo {
                            lastAccNo = Int(fd.accountNo)!
                        }
                    }
                    
                    if let sal = cust.accounts!.salaryAcc {
                        if Int(sal.accountNo)! > lastAccNo {
                            lastAccNo = Int(sal.accountNo)!
                        }
                    }
                    
                    if let sav = cust.accounts!.savingsAcc {
                        if Int(sav.accountNo)! > lastAccNo {
                            lastAccNo = Int(sav.accountNo)!
                        }
                    }
                    
                }
            }
            
        }
        
        accNo = lastAccNo + 1
        Constants.lastAccountNumber = accNo
        return String(format: "%03d", accNo)
    }
    
    func createSalaryAcc() -> SalaryAccount {
        let accNo = BankTransationService.shared.generateNextAccountNumber()
        print("Enter the account balance you'd like to add:")
        let accBal = Double(readLine()!)!
        print("Enter the name of your employer: ")
        let employer = readLine()!
        print("Enter your monthly salary: ")
        let monthlySal = Double(readLine()!)!

        return SalaryAccount(accNo: accNo, accBalance: accBal, employer: employer, monthlySalary: monthlySal)
    }

    func createSavingAcc() -> SavingsAccount {
        let accNo = BankTransationService.shared.generateNextAccountNumber()
        print("Minimum balance you need to maintain is: \(Constants.savingMinBal)\nAnd interest rate is: \(Constants.savingIntRate)%")
        
        var accBal = Double(0)
        var rep = false
        repeat {
            print("Enter the account balance you'd like to add:")
            accBal = Double(readLine()!)!
            if accBal > Constants.savingMinBal {
                rep = false
            }
            else {
                print("Please enter amount more than \(Constants.savingMinBal)")
                rep = true
            }
        }
        while rep
                
                return SavingsAccount(accNo: accNo, accBalance: accBal, minBal: Constants.savingMinBal, intRate: Constants.savingIntRate)
    }

    func createFdAcc() -> FixedDepositAccount {
        let accNo = BankTransationService.shared.generateNextAccountNumber()
        print("Enter the account balance you'd like to add:")
        let accBal = Double(readLine()!)!
        print("Enter the number of months as term duration for FD: ")
        let termDur = Int(readLine()!)!
        
        print("Interest rate for Fixed Deposit is \(Constants.fdIntRate)%")
        
        return FixedDepositAccount(accNo: accNo, accBalance: accBal, termDur: termDur, intRate: Constants.fdIntRate)
    }
}
