import HeliumLogger
import Kitura
import MongoKitten

HeliumLogger.use()

/*
 This example stores projects in a local MongoDB.
 The MongoKitten driver provides a Document type to store and retrieve data as BSON.
 Document is easy to use because it uses dictionary syntax, similar to how JSON works in Swift.
 Examples on how to use BSON can be found in the extensions on Color, Project and Task.
 */
let database = try! Database("mongodb://127.0.0.1:27017/2dehandsdb")

let router = Router()
router.all(middleware: BodyParser())
configureUsersRouter(on: router.route("/api"))

Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()

