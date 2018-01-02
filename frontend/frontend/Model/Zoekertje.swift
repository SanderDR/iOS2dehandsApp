import Foundation

class Zoekertje: Codable{
    var name: String
    var description: String
    var price: Int
    var location: String
    var by: User
    
    init(name:String, description: String, price:Int, location: String, by: User){
        self.name = name
        self.description = description
        self.price = price
        self.location = location
        self.by = by
    }
    
}

