//
//  AddPasswordViewController.swift
//  google_password_manager
//
//  Created by Venkata Macha on 8/16/16.
//  Copyright © 2016 Venkata Macha. All rights reserved.
//

import UIKit

class AddPasswordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var delegate: PasswordsViewController?
    var editingMode: Bool?
    var previousPassword: UserPassword?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let passwordNib = UINib(nibName: "PasswordFieldCell", bundle: nil)
        tableView.registerNib(passwordNib, forCellReuseIdentifier: "PasswordFieldCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 82
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1;
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PasswordFieldCell", forIndexPath: indexPath) as! PasswordFieldCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        switch indexPath.row {
        case 0:
            cell.label.text = "Service:"
        case 1:
            cell.label.text = "Username:"
        case 2:
            cell.label.text = "Password:"
        case 3:
            cell.label.text = "Notes:"
            
        default:
            break
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }

}
