import CryptoKitten
import Foundation
import CryptoTokenKit

class User: Codable{
    var name: String
    var username: String
    var email: String
    var salt: String
    var hash: String
    
    init(name: String, username: String, email:String, password:String){
        self.email = email
        self.name = name
        self.username = username
        let salt1 = User.randomAlphaNumericString(length: 10)
        self.salt = String(bytes: salt1, encoding: .utf8)!
        self.hash = NSData(bytes: try! PBKDF2_HMAC<SHA256>.derive(fromPassword: Array(password.utf8), saltedWith: salt1), length: try! PBKDF2_HMAC<SHA256>.derive(fromPassword: Array(password.utf8), saltedWith: salt1).count).base64EncodedString()
    }
    
    init(name: String, username: String, email:String, hash:String, salt:String){
        self.email = email
        self.name = name
        self.username = username
        self.salt = salt
        self.hash = hash
    }
    
    private class func randomAlphaNumericString(length: Int) -> [UInt8] {
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.characters.count)
        var randomString = ""
        
        for _ in 0..<length {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
            let newCharacter = allowedChars[randomIndex]
            randomString += String(newCharacter)
        }
        
        return Array(randomString.utf8)
    }
    
    func login(password: String) -> Bool{
        let passwordHashed = NSData(bytes: try! PBKDF2_HMAC<SHA256>.derive(fromPassword: Array(password.utf8), saltedWith: Array(self.salt.utf8)), length: try! PBKDF2_HMAC<SHA256>.derive(fromPassword: Array(password.utf8), saltedWith: Array(self.salt.utf8)).count).base64EncodedString()
        if(passwordHashed == self.hash){
            return true
        }else{
            return false
        }
        
    }

}

import BSON

extension User {
    
    convenience init?(from bson: Document) {
        guard let name = String(bson["name"]),
            let username = String(bson["username"]),
            let email = String(bson["email"]),
            let salt = String(bson["salt"]),
            let hash = String(bson["hash"]) else {
                return nil
        }
        self.init(name: name, username: username, email:email, hash:hash, salt:salt)
    }
    
    func toBSON() -> Document {
        return [
            "name": name,
            "email": email,
            "username": username,
            "hash": hash,
            "salt": salt
            
        ]
    }
}
