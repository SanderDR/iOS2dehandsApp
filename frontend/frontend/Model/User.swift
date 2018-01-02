import Foundation

class User: Codable{
    var username: String
    var name: String
    var email: String
    var password: String
    
    init(username: String, name: String, email:String, password: String){
        self.username = username
        self.name = name
        self.email = email
        self.password = password
    }
    
}
