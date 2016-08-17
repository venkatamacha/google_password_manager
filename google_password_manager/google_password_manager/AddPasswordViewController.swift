//
//  AddPasswordViewController.swift
//  google_password_manager
//
//  Created by Venkata Macha on 8/16/16.
//  Copyright © 2016 Venkata Macha. All rights reserved.
//

import UIKit

class AddPasswordViewController: UIViewController {
    
    var delegate: PasswordsViewController?
    
    @IBOutlet weak var service: UITextField!
    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var notes: UITextField!
}
