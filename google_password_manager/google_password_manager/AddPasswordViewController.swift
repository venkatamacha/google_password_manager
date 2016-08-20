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
    var previousPassword: UserPassword?
    
    var service: UITextField?
    var user: UITextField?
    var pass: UITextField?
    var notes: UITextField?
    
    
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
            service = cell.textField
        case 1:
            cell.label.text = "Username:"
            user = cell.textField
        case 2:
            cell.label.text = "Password:"
            pass = cell.textField
        case 3:
            cell.label.text = "Notes:"
            notes = cell.textField
        default:
            break
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }

    @IBAction func save_action(sender: AnyObject) {
        if previousPassword != nil {
            previousPassword!.deleteSelfFromFile()
        }
        UserPassword.init(uuid: nil, service: (service!.text) ?? "Untitled", user: user!.text, pass: pass!.text, notes: notes!.text).insertSelfIntoFile()
        self.navigationController!.popViewControllerAnimated(true)
    }

    @IBAction func delete_action(sender: AnyObject) {
        if previousPassword != nil {
            previousPassword!.deleteSelfFromFile()
        }
        self.navigationController!.popViewControllerAnimated(true)
    }
    
}
