import UIKit
class MenuViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var allAdsButton: UIButton!
    @IBOutlet weak var yourAdsButton: UIButton!
    @IBOutlet weak var postAdButton: UIButton!
    
    override func viewDidLoad() {
        self.navigationController!.navigationBar.topItem!.title = "Log out"
        let defaults = UserDefaults.standard
        welcomeLabel.text = "Welcome, " + defaults.string(forKey: "username")!
    }

    @IBAction func unwindToMenu(segue:UIStoryboardSegue) {
        switch segue.identifier {
        case "didPostAd"?:
            _ = segue.source as! PostAdViewController
        default:
            fatalError("Unkown segue")
        }
    }
}
