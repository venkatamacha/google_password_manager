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
    
    init(uuid: String?, service: String, user: String?, pass: String?, notes: String?){
        self.uuid = uuid ?? NSUUID().UUIDString
        self.service = service
        self.user = user
        self.pass = pass
        self.notes = notes
    }
    
    func textVersion() -> String{
        if service == "" {
            service = "Untitled"
        }
        
        if user == "" {
            user = "!@#$%^&*()"
        }
        
        if pass == "" {
            pass = "!@#$%^&*()"
        }
        
        if notes == "" {
            notes = "!@#$%^&*()"
        }

        return (uuid + "," +
                service + "," +
                user! + "," +
                pass! + "," +
                notes!)
    }
    
    func deleteSelfFromFile(vc: PasswordsViewController){
        var userPasswordTexts = vc.fileText.characters.split{$0 == ";"}.map(String.init)
        userPasswordTexts = userPasswordTexts.filter{!$0.hasPrefix(uuid)}
        vc.fileText = userPasswordTexts.joinWithSeparator(";")
    }
    
    func insertSelfIntoFile(vc: PasswordsViewController){
        var userPasswordTexts = vc.fileText.characters.split{$0 == ";"}.map(String.init)
        userPasswordTexts.append(textVersion())
        vc.fileText = userPasswordTexts.joinWithSeparator(";")
    }
    
    static func generatePasswordDictionary(vc: PasswordsViewController) -> [Character: [UserPassword]]{
        var passwordDictionary: [Character: [UserPassword]] = [:]
        
        let userPasswordTexts = vc.fileText.characters.split{$0 == ";"}.map(String.init)
        for text in userPasswordTexts {
            let userPasswordFields = text.characters.split{$0 == ","}.map(String.init).map{(s1: String) -> String? in if s1 == "!@#$%^&*()" {return nil} else {return s1}}
            let userPassword = UserPassword.init(uuid: userPasswordFields[0]!, service: userPasswordFields[1]!, user: userPasswordFields[2], pass: userPasswordFields[3], notes: userPasswordFields[4])
            
            let firstCharacter = userPassword.service.uppercaseString[userPassword.service.startIndex]
            if passwordDictionary[firstCharacter] != nil {
                passwordDictionary[firstCharacter]!.append(userPassword)
            } else {
                passwordDictionary[firstCharacter] = [userPassword]
            }
        }
        
        return passwordDictionary
    }
}