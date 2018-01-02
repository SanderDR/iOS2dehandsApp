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
import BSON

extension Zoekertje {
    
    convenience init?(from bson: Document) {
        guard let name = String(bson["name"]),
            let description = String(bson["description"]),
            let price = Int(bson["price"]),
            let location = String(bson["location"]),
            let bsonBy = Document(bson["by"]),
            let by = User(from: bsonBy) else  {
                return nil
        }
        
        self.init(name: name, description: description, price:price, location:location, by:by)
    }
    
    func toBSON() -> Document {
        return [
            "name": name,
            "description": description,
            "price": price,
            "location": location,
            "by": by.toBSON()
            
        ]
    }
}
