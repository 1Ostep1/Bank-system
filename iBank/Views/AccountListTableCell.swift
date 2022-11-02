//
//  AccountListTableCell.swift
//  iBank
//
//  Created by Keval on 3/24/21.
//

import UIKit

class AccountListTableCell: UITableViewCell {
    
    @IBOutlet weak var label_accType: UILabel!
    @IBOutlet weak var label_accBalance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(accType: String, accBalance: Double) {
        label_accType.text = "\(accType):"
        label_accBalance.text = "$ \(String(format: "%.2f", accBalance))"
    }

}
