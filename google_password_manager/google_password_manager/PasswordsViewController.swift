//
//  PasswordsViewController.swift
//  google_password_manager
//
//  Created by Venkata Macha on 8/14/16.
//  Copyright © 2016 Venkata Macha. All rights reserved.
//

import GoogleAPIClient
import GTMOAuth2
import UIKit
import CryptoSwift

class PasswordsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    private let kKeychainItemName = "Drive API"
    private let kClientID = "741471521408-8m4u1gj5m98o7qiefibvhtt15qsk2oj4.apps.googleusercontent.com"
    private let setup = try! AES(key: "thebirdistheword", iv: "0123456789012345")
    
    var firstTimeViewDidAppearWasCalled: Bool = true
    var timesViewWillAppearWasCalled: Int = 0
    var userPasswords: [Character: [UserPassword]] = [:]
    
    var segueRow: Int?
    var segueSection: Int?
    
    var file: GTLDriveFile?
    var identifier: String?
    
    var fileText: String = ""
    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    private let scopes = [kGTLAuthScopeDrive]
    
    private let service = GTLServiceDrive()
    
    // When the view loads, create necessary subviews
    // and initialize the Drive API service
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychainForName(
            kKeychainItemName,
            clientID: kClientID,
            clientSecret: nil) {
            service.authorizer = auth
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if firstTimeViewDidAppearWasCalled {
            presentViewController(
                createAuthController(),
                animated: true,
                completion: nil
            )
            firstTimeViewDidAppearWasCalled = false
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if (timesViewWillAppearWasCalled == 1) {
            if let authorizer = service.authorizer,
                canAuth = authorizer.canAuthorize where canAuth {
                fetchFiles()
            } else {
                presentViewController(
                    createAuthController(),
                    animated: true,
                    completion: nil
                )
            }
        }
        self.userPasswords = UserPassword.generatePasswordDictionary(self)
        self.tableView.reloadData()
        timesViewWillAppearWasCalled += 1
    }
    
    // Construct a query to get names and IDs of 10 files using the Google Drive API
    func fetchFiles() {
        let query = GTLQueryDrive.queryForFilesList()
        query.pageSize = 10
        query.fields = "nextPageToken, files(id, name)"
        service.executeQuery(
            query,
            delegate: self,
            didFinishSelector: #selector(PasswordsViewController.displayResultWithTicket(_:finishedWithObject:error:))
        )
    }
    
    // Parse results and display
    func displayResultWithTicket(ticket : GTLServiceTicket,
                                 finishedWithObject response : GTLDriveFileList,
                                                    error : NSError?) {
        
        if let error = error {
            showAlert("Error", message: error.localizedDescription)
            return
        }
        
        var filesString = ""
        
        if let files = response.files where !files.isEmpty {
            filesString += "Files:\n"
            for file in files as! [GTLDriveFile] {
                filesString += "\(file.name) (\(file.identifier))\n"
                
                if file.name == "password.txt" {
                    self.file = file
                    self.identifier = file.identifier
                }
            }
        } else {
            filesString = "No files found."
        }
        
        pullData()
    }
    
    @IBAction func pushData(sender: AnyObject) {
        let name = "password.txt"
        let content = fileText
        let mimeType = "text/plain"
        let metadata = GTLDriveFile()
        metadata.name = name
        let data = try! content.dataUsingEncoding(NSUTF8StringEncoding)?.encrypt(setup)
        let uploadParameters = GTLUploadParameters()
        uploadParameters.data = data
        uploadParameters.MIMEType = mimeType
        
        let query: GTLQueryDrive
        if file != nil {
            query = GTLQueryDrive.queryForFilesUpdateWithObject(metadata, fileId: identifier!, uploadParameters: uploadParameters)
        } else {
            query = GTLQueryDrive.queryForFilesCreateWithObject(metadata, uploadParameters: uploadParameters)
        }
        
        service.executeQuery(query, completionHandler: {(ticket: GTLServiceTicket!, updatedFile: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                print("File \(updatedFile)")
                if let file = updatedFile as? GTLDriveFile {
                    self.file = file
                    self.identifier = file.identifier
                } else {
                    print("Can't recognize password.txt file")
                }
            }
            else {
                print("An error occurred: \(error!)")
            }
        })
    }
    
    func pullData(){
        if file != nil {
            service.fetcherService.fetcherWithURLString("https://www.googleapis.com/drive/v3/files/\(identifier!)?alt=media").beginFetchWithCompletionHandler({(data, error) in
                if (error == nil) {
                    print("Retrieved file content");
                    self.fileText = String(data: try! data!.decrypt(self.setup), encoding: NSUTF8StringEncoding)!
                    self.userPasswords = UserPassword.generatePasswordDictionary(self)
                    self.tableView.reloadData()
                } else {
                    print("An error occurred: \(error!)")
                }
            })
        }
    }
    
    // Creates the auth controller for authorizing access to Drive API
    private func createAuthController() -> GTMOAuth2ViewControllerTouch {
        let scopeString = scopes.joinWithSeparator(" ")
        return GTMOAuth2ViewControllerTouch(
            scope: scopeString,
            clientID: kClientID,
            clientSecret: nil,
            keychainItemName: kKeychainItemName,
            delegate: self,
            finishedSelector: #selector(PasswordsViewController.viewController(_:finishedWithAuth:error:))
        )
    }
    
    // Handle completion of the authorization process, and update the Drive API
    // with the new credentials.
    func viewController(vc : UIViewController,
                        finishedWithAuth authResult : GTMOAuth2Authentication, error : NSError?) {
        
        if let error = error {
            service.authorizer = nil
            showAlert("Authentication Error", message: error.localizedDescription)
            return
        }
        
        service.authorizer = authResult
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.Default,
            handler: nil
        )
        alert.addAction(ok)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return userPasswords.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPasswords[Array(userPasswords.keys).sort{$0 < $1}[section]]!.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35;
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(Array(userPasswords.keys).sort{$0 < $1}[section])
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PasswordItemCell", forIndexPath: indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.text = userPasswords[Array(userPasswords.keys).sort{$0 < $1}[indexPath.section]]![indexPath.row].service
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "editPassword" {
            let vc = segue.destinationViewController as! AddPasswordViewController
            vc.delegate = self
            vc.previousPassword = userPasswords[Array(userPasswords.keys).sort{$0 < $1}[segueSection!]]![segueRow!]
        } else {
            let vc = segue.destinationViewController as! AddPasswordViewController
            vc.delegate = self
            vc.previousPassword = nil
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        segueRow = indexPath.row
        segueSection = indexPath.section
        performSegueWithIdentifier("editPassword", sender: nil)
    }
    
    
}

