//
//  UserPassword.swift
//  google_password_manager
//
//  Created by Venkata Macha on 8/14/16.
//  Copyright © 2016 Venkata Macha. All rights reserved.
//

import Foundation

class UserPassword: NSObject {
    var uuid: String
    var service: String
    var user: String?
    var pass: String?
    var notes: String?
    
    init(service: String, user: String?, pass: String?, notes: String?){
        self.uuid = NSUUID().UUIDString
        self.service = service
        self.user = user
        self.pass = pass
        self.notes = notes
    }
    
    func textVersion() -> String{
        return (uuid + "," +
                service + "," +
                (user ?? "") + "," +
                (pass ?? "") + "," +
                (notes ?? ""))
    }
    
    func deleteSelfFromFile(){
        let oldText = UserPassword.readFromFile()
        var userPasswordTexts = oldText.characters.split{$0 == ";"}.map(String.init)
        userPasswordTexts = userPasswordTexts.filter{!$0.hasPrefix(uuid)}
        let newText = userPasswordTexts.joinWithSeparator(";")
        UserPassword.writeIntoFile(newText)
    }
    
    func insertSelfIntoFile(){
        let oldText = UserPassword.readFromFile()
        var userPasswordTexts = oldText.characters.split{$0 == ";"}.map(String.init)
        userPasswordTexts.append(textVersion())
        let newText = userPasswordTexts.joinWithSeparator(";")
        UserPassword.writeIntoFile(newText)
    }
    
    static func writeIntoFile(text: String){
        
    }
    
    static func readFromFile() -> String{
        return ""
    }
}