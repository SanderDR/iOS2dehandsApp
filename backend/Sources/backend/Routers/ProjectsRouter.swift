import Foundation
import Kitura
import KituraContracts
import LoggerAPI
import MongoKitten

private let users = database["users"]
private let zoekertjes = database["zoekertjes"]

func configureUsersRouter(on router: Router) {
    
    router.post("/register") { request, response, next in
        guard let parsedBody = request.body else {
            next()
            return
        }
        switch parsedBody {
        case .json(let jsonBody):
            guard try users.count(["username": jsonBody["username"] as? String]) == 0 else {
                response.send("user allready exists")
                next()
                return
            }
            guard jsonBody.count == 4 else {
                response.send("please fill out all fields")
                next()
                return
            }
            let user: User = User(name: jsonBody["name"] as! String, username: jsonBody["username"] as! String, email: jsonBody["email"] as! String, password: jsonBody["password"] as! String)
            try users.insert(user.toBSON())
            try response.send(user).end()
        default:
            break
        }
        next()
    }
    router.post("/login") { request, response, next in
        guard let parsedBody = request.body else {
            next()
            return
        }
        switch parsedBody {
        case .json(let jsonBody):
            guard try users.count(["username": jsonBody["username"] as? String]) == 1 else {
                response.send(status: .notFound)
                next()
                return
            }
            guard jsonBody.count == 2 else {
                response.send(status: .notAcceptable)
                next()
                return
            }
            let bson = try users.findOne("username" == jsonBody["username"] as! String)
            let user = User(from: bson!)
            guard try user!.login(password: jsonBody["password"] as! String) else {
                response.send(status: .unauthorized)
                next()
                return
            }
            try response.send(json: ["username" : user!.username, "name":user!.name, "email": user!.email, "password":jsonBody["password"] as! String]).end()
            default:
            break
        }
        next()
    }
    router.post("/postAd") { request, response, next in
        guard let parsedBody = request.body else {
            try response.send(status: .noContent).end()
            next()
            return
        }
        guard let authHeader = request.headers["Authorization"] else{
            try response.send(status: .unauthorized).end()
            next()
            return
        }
        
        
        let username = authHeader.split(separator: ":").first!
        print(username)
        let password = authHeader.split(separator: ":").last!
        print(password)
 
        switch parsedBody {
        case .json(let jsonBody):
            guard try users.count(["username" : String(username)]) == 1 else {
                try response.send(status: .notFound).end()
                next()
                return
            }
            guard jsonBody.count == 4 else {
                try response.send(status: .notAcceptable).end()
                next()
                return
            }
            let bson = try users.findOne("username" == String(username))
            let user = User(from: bson!)
            guard user!.login(password: String(password)) else {
                try response.send(status: .unauthorized).end()
                next()
                return
            }
            let zoekertje = Zoekertje(name: jsonBody["name"] as! String, description: jsonBody["description"] as! String, price: jsonBody["price"] as! Int, location: jsonBody["location"] as! String, by: user!)
            guard try zoekertjes.count(["name":zoekertje.name, "by.username":zoekertje.by.username]) == 0 else {
                try response.send(status: .forbidden).end()
                next()
                return
            }
            try zoekertjes.insert(zoekertje.toBSON())
            try response.send(zoekertje).end()
        default:
            break
        }
        next()
    }
    router.get("/myAds") { request, response, next in
        guard let authHeader = request.headers["Authorization"] else{
            try response.send(status: .unauthorized).end()
            next()
            return
        }
        
        let username = authHeader.split(separator: ":").first!
        print(username)
        let password = authHeader.split(separator: ":").last!
        print(password)
        
        guard try users.count(["username" : String(username)]) == 1 else {
            try response.send(status: .notFound).end()
            next()
            return
        }
        let bsonUser = try users.findOne("username" == String(username))
        let user = User(from: bsonUser!)
        guard user!.login(password: String(password)) else {
            try response.send(status: .unauthorized).end()
            next()
            return
        }
        let bson = try zoekertjes.find(["by.username": String(username)])
        var result = [Zoekertje]()
        for doc in bson {
            result.append(Zoekertje(from:doc)!)
        }
        try response.send(result).end()
        next()
    }
    router.delete("/remove") { request, response, next in
        guard let parsedBody = request.body else {
            try response.send(status: .noContent).end()
            next()
            return
        }
        guard let authHeader = request.headers["Authorization"] else{
            try response.send(status: .unauthorized).end()
            next()
            return
        }
        
        let username = authHeader.split(separator: ":").first!
        print(username)
        let password = authHeader.split(separator: ":").last!
        print(password)
        
        switch parsedBody {
        case .json(let jsonBody):
            guard try users.count(["username" : String(username)]) == 1 else {
                try response.send(status: .notFound).end()
                next()
                return
            }
            guard jsonBody.count == 1 else {
                try response.send(status: .notAcceptable).end()
                next()
                return
            }
            let bsonUser = try users.findOne("username" == String(username))
            let user = User(from: bsonUser!)
            guard user!.login(password: String(password)) else {
                try response.send(status: .unauthorized).end()
                next()
                return
            }
            guard try zoekertjes.count(["name":jsonBody["name"] as! String, "by.username":String(username)]) == 1 else {
                try response.send(status: .notFound).end()
                next()
                return
            }
            try zoekertjes.remove(["name":jsonBody["name"] as! String, "by.username":String(username)])
            try response.send("Removed ad").end()
        default:
            break
        }
        next()
    }
    router.put("/update") { request, response, next in
        guard let parsedBody = request.body else {
            try response.send(status: .noContent).end()
            next()
            return
        }
        guard let authHeader = request.headers["Authorization"] else{
            try response.send(status: .unauthorized).end()
            next()
            return
        }
        
        let username = authHeader.split(separator: ":").first!
        print(username)
        let password = authHeader.split(separator: ":").last!
        print(password)
        
        switch parsedBody {
        case .json(let jsonBody):
            guard try users.count(["username" : String(username)]) == 1 else {
                try response.send(status: .notFound).end()
                next()
                return
            }
            guard jsonBody.count == 5 else {
                try response.send(status: .notAcceptable).end()
                next()
                return
            }
            guard try zoekertjes.count(["name":jsonBody["oldName"] as! String, "by.username":String(username)]) == 1 else {
                try response.send(status: .notFound).end()
                next()
                return
            }
            let bsonUser = try users.findOne("username" == String(username))
            let user = User(from: bsonUser!)
            guard user!.login(password: String(password)) else {
                try response.send(status: .unauthorized).end()
                next()
                return
            }
            let bsonAd = try zoekertjes.findOne("by.username" == String(username) && "name" == jsonBody["oldName"] as! String)
            let ad = Zoekertje(from: bsonAd!)
            ad!.name = jsonBody["name"] as! String
            ad!.description = jsonBody["description"] as! String
            ad!.price = jsonBody["price"] as! Int
            ad!.location = jsonBody["location"] as! String
            try zoekertjes.update(["name":jsonBody["oldName"] as! String, "by.username": String(username)], to: ad!.toBSON())
            try response.send("Updated ad").end()
        default:
            break
        }
        next()
    }
    router.get("/ads", handler: getAllAds)
}

private func getAllAds(completion: ([Zoekertje]?, RequestError?) -> Void) {
    do {
        let results = try zoekertjes.find().flatMap(Zoekertje.init)
        completion(results, nil)
    } catch {
        Log.error(error.localizedDescription)
        completion(nil, .internalServerError)
    }
}
