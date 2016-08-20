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
        return (uuid + "," +
                service + "," +
                (user ?? "") + "," +
                (pass ?? "") + "," +
                (notes ?? ""))
    }
    
    func deleteSelfFromFile(){
        var fileText = UserPassword.readFromFile()
        var userPasswordTexts = fileText.characters.split{$0 == ";"}.map(String.init)
        userPasswordTexts = userPasswordTexts.filter{!$0.hasPrefix(uuid)}
        fileText = userPasswordTexts.joinWithSeparator(";")
        UserPassword.writeIntoFile(fileText)
    }
    
    func insertSelfIntoFile(){
        var fileText = UserPassword.readFromFile()
        var userPasswordTexts = fileText.characters.split{$0 == ";"}.map(String.init)
        userPasswordTexts.append(textVersion())
        fileText = userPasswordTexts.joinWithSeparator(";")
        UserPassword.writeIntoFile(fileText)
    }
    
    static func writeIntoFile(text: String){
        
    }
    
    static func readFromFile() -> String{
        return ""
    }
    
    static func generatePasswordDictionary() -> [String: [UserPassword]]{
        var passwordDictionary: [String: [UserPassword]] = [:]
        
        let userPasswordTexts = UserPassword.readFromFile().characters.split{$0 == ";"}.map(String.init)
        for text in userPasswordTexts {
            let userPasswordFields = text.characters.split{$0 == ","}.map(String.init).map{(s1: String) -> String? in if s1 == "" {return nil} else {return s1}}
            let userPassword = UserPassword.init(uuid: userPasswordFields[0]!, service: userPasswordFields[1]!, user: userPasswordFields[2], pass: userPasswordFields[3], notes: userPasswordFields[4])
            
            let firstCharacter = Array(arrayLiteral: userPassword.service.capitalizedString)[0]
            if passwordDictionary[firstCharacter] != nil {
                passwordDictionary[firstCharacter]!.append(userPassword)
            } else {
                passwordDictionary[firstCharacter] = [userPassword]
            }
        }
        
        return passwordDictionary
    }
}