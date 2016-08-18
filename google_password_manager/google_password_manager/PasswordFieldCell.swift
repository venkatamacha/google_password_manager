//
//  PasswordFieldCell.swift
//  google_password_manager
//
//  Created by Venkata Macha on 8/18/16.
//  Copyright © 2016 Venkata Macha. All rights reserved.
//

import UIKit

class PasswordFieldCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
