import KituraKit

/*
 This class provides methods to communicate with the back-end.
 This communication is done using KituraKit, which works much like the codable routing APIs on the back-end.
 */
class KituraService {
    
    /*
     Singleton.
     */
    private init() { }
    static let shared = KituraService()
    
    private let client = KituraKit(baseURL: "http://localhost:8080/api/")!
    
    func login(username:String, password: String, completion: @escaping (User) -> Void) -> Void{
        var request = URLRequest(url:URL(string:"http://localhost:8080/api/login")!)
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        let params = ["username":username, "password":password]
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options:.prettyPrinted)
        }catch let error{
            print(error.localizedDescription)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let loggedInUser: User = User(username: username, name: "", email: "", password: password)
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            guard let _:Data = data else{
                completion(loggedInUser)
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            
            if(httpResponse.statusCode == 200){
            let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
            loggedInUser.email = json!!["email"] as! String
            loggedInUser.name = json!!["name"] as! String
            }
            completion(loggedInUser)
        })
        task.resume()
    }
    
    func add(_ zoekertje: Zoekertje, completion: @escaping (Zoekertje) -> Void) -> Void{
        var request = URLRequest(url:URL(string:"http://localhost:8080/api/postAd")!)
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        let params = ["name":zoekertje.name, "description":zoekertje.description, "price": zoekertje.price, "location":zoekertje.location] as [String : Any]
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options:.prettyPrinted)
        }catch let error{
            print(error.localizedDescription)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(NSString(format: "%@:%@", zoekertje.by.username, zoekertje.by.password) as String, forHTTPHeaderField: "Authorization")
        
        var result = Zoekertje(name: "", description: "", price: 0, location: "", by: zoekertje.by)
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            guard let _:Data = data else{
                completion(result)
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            
            if(httpResponse.statusCode == 200){
                result = zoekertje
            }
            completion(result)
        })
        task.resume()
    }
    
    func getAds(completion: @escaping ([Zoekertje]) -> Void) -> Void{
        var request = URLRequest(url:URL(string:"http://localhost:8080/api/ads")!)
        let session = URLSession.shared
        request.httpMethod = "GET"
        
        var result = [Zoekertje]()
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            guard let _:Data = data else{
                completion(result)
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            
            if(httpResponse.statusCode == 200){
                let json = try? JSONSerialization.jsonObject(with: data!, options: []) as! [[String: Any]]
                for zoekertje in json!{
                    var by = zoekertje["by"] as! [String: Any]
                    result.append(Zoekertje(name: zoekertje["name"] as! String, description: zoekertje["description"] as! String, price: zoekertje["price"] as! Int, location: zoekertje["location"] as! String, by: User(username: by["username"] as! String, name: by["name"] as! String, email: by["email"] as! String, password:"secret")))
                }
            }
            completion(result)
        })
        task.resume()
    }
    
    func myAds(completion: @escaping ([Zoekertje]) -> Void) -> Void{
        var request = URLRequest(url:URL(string:"http://localhost:8080/api/myAds")!)
        let session = URLSession.shared
        request.httpMethod = "GET"
        
        let defaults = UserDefaults.standard
        request.addValue(NSString(format: "%@:%@", defaults.string(forKey: "username")!, defaults.string(forKey: "password")!) as String, forHTTPHeaderField: "Authorization")
        
        var result = [Zoekertje]()
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            guard let _:Data = data else{
                completion(result)
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            
            if(httpResponse.statusCode == 200){
                let json = try? JSONSerialization.jsonObject(with: data!, options: []) as! [[String: Any]]
                for zoekertje in json!{
                    var by = zoekertje["by"] as! [String: Any]
                    result.append(Zoekertje(name: zoekertje["name"] as! String, description: zoekertje["description"] as! String, price: zoekertje["price"] as! Int, location: zoekertje["location"] as! String, by: User(username: by["username"] as! String, name: by["name"] as! String, email: by["email"] as! String, password:"secret")))
                }
            }
            completion(result)
        })
        task.resume()
    }
    
    func register(user: User, completion: @escaping (User) -> Void) -> Void{
        var request = URLRequest(url:URL(string:"http://localhost:8080/api/register")!)
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        let params = ["username":user.username, "name": user.name, "email": user.email, "password":user.password]
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options:.prettyPrinted)
        }catch let error{
            print(error.localizedDescription)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let loggedInUser: User = User(username: user.username, name: "", email: "", password: user.password)
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            guard let _:Data = data else{
                completion(loggedInUser)
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            
            if(httpResponse.statusCode == 200){
                let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                loggedInUser.email = json!!["email"] as! String
                loggedInUser.name = json!!["name"] as! String
            }
            completion(loggedInUser)
        })
        task.resume()
    }
    
    func remove(zoekertje: Zoekertje, completion: @escaping (Bool) -> Void) -> Void{
        var request = URLRequest(url:URL(string:"http://localhost:8080/api/remove")!)
        let session = URLSession.shared
        request.httpMethod = "DELETE"
        
        let params = ["name":zoekertje.name]
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options:.prettyPrinted)
        }catch let error{
            print(error.localizedDescription)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let defaults = UserDefaults.standard
        request.addValue(NSString(format: "%@:%@", defaults.string(forKey: "username")!, defaults.string(forKey: "password")!) as String, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            guard let _:Data = data else{
                completion(false)
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            
            if(httpResponse.statusCode == 200){
                completion(true)
            }else{
                completion(false)
            }
        })
        task.resume()
    }
    
    func updateAd(withName: String, zoekertje: Zoekertje, completion: @escaping (Bool) -> Void) -> Void{
        var request = URLRequest(url:URL(string:"http://localhost:8080/api/update")!)
        let session = URLSession.shared
        request.httpMethod = "PUT"
        
        let params = ["oldName":withName,"name":zoekertje.name, "description":zoekertje.description, "location": zoekertje.location, "price": zoekertje.price] as [String : Any]
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options:.prettyPrinted)
        }catch let error{
            print(error.localizedDescription)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let defaults = UserDefaults.standard
        request.addValue(NSString(format: "%@:%@", defaults.string(forKey: "username")!, defaults.string(forKey: "password")!) as String, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            guard let _:Data = data else{
                completion(false)
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            
            if(httpResponse.statusCode == 200){
                completion(true)
            }else{
                completion(false)
            }
        })
        task.resume()
    }


}
