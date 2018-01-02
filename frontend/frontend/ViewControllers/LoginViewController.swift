import UIKit

class LoginViewController: UITableViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
    }
    
    @IBAction func hideKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func login() {
        let username = usernameField.text!
        let password = passwordField.text!
        
        if(username == ""  || password == ""){
            return
        }
        
       customActivityIndicatory(self.view, startAnimate: true)
        KituraService.shared.login(username:username, password:password){ (user: User) in
            DispatchQueue.main.async() {
            if(user.name != ""){
                let defaults = UserDefaults.standard
                defaults.set(user.username, forKey: "username")
                defaults.set(user.name, forKey: "name")
                defaults.set(user.email, forKey: "email")
                defaults.set(user.password, forKey: "password")
                customActivityIndicatory(self.view, startAnimate: false)
                self.performSegue(withIdentifier: "loginSuccesfull", sender: self)
            }else{
                customActivityIndicatory(self.view, startAnimate: false)
                let alert = UIAlertController(title: "Login", message: "Login Failed", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "loginSuccesfull"?:
            _ = segue.destination as! MenuViewController
        default:
            break
        }
    }
    
    @IBAction func unwindToLogin(segue:UIStoryboardSegue) {
        switch segue.identifier {
        case "didLogout"?:
            _ = segue.source as! MenuViewController
        default:
            fatalError("Unkown segue")
        }
    }
}

//Source: https://medium.com/@sourleangchhean/ios-customized-activity-indicator-with-swift-3-0-2-f26f7dd6a064
@discardableResult
func customActivityIndicatory(_ viewContainer: UIView, startAnimate:Bool? = true) -> UIActivityIndicatorView {
    let mainContainer: UIView = UIView(frame: viewContainer.frame)
    mainContainer.center = viewContainer.center
    mainContainer.backgroundColor = UIColor.init(netHex: 0xFFFFFF)
    mainContainer.alpha = 0.5
    mainContainer.tag = 789456123
    mainContainer.isUserInteractionEnabled = false
    
    let viewBackgroundLoading: UIView = UIView(frame: CGRect(x:0,y: 0,width: 80,height: 80))
    viewBackgroundLoading.center = viewContainer.center
    viewBackgroundLoading.backgroundColor = UIColor.init(netHex: 0x444444)
    viewBackgroundLoading.alpha = 0.5
    viewBackgroundLoading.clipsToBounds = true
    viewBackgroundLoading.layer.cornerRadius = 15
    
    let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    activityIndicatorView.frame = CGRect(x:0.0,y: 0.0,width: 40.0, height: 40.0)
    activityIndicatorView.activityIndicatorViewStyle =
        UIActivityIndicatorViewStyle.whiteLarge
    activityIndicatorView.center = CGPoint(x: viewBackgroundLoading.frame.size.width / 2, y: viewBackgroundLoading.frame.size.height / 2)
    if startAnimate!{
        viewBackgroundLoading.addSubview(activityIndicatorView)
        mainContainer.addSubview(viewBackgroundLoading)
        viewContainer.addSubview(mainContainer)
        activityIndicatorView.startAnimating()
    }else{
        for subview in viewContainer.subviews{
            if subview.tag == 789456123{
                subview.removeFromSuperview()
            }
        }
    }
    return activityIndicatorView
}

//Source: https://stackoverflow.com/questions/31782316/how-to-create-a-hex-color-string-uicolor-initializer-in-swift
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
