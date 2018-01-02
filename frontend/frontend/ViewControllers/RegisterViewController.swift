import UIKit
class RegisterViewController: UITableViewController{
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var registerButton: UIBarButtonItem!
    
    @IBAction func register() {
        let username = usernameField.text!
        let password = passwordField.text!
        let email = emailField.text!
        let name = nameField.text!
        
        if(username == ""  || password == ""){
            return
        }
        
        registerButton.isEnabled = false
        customActivityIndicatory(self.view, startAnimate: true)
        let user = User(username: username, name: name, email: email, password: password)
        KituraService.shared.register(user: user){ (user: User) in
            DispatchQueue.main.async() {
                if(user.name != ""){
                    let defaults = UserDefaults.standard
                    defaults.set(user.username, forKey: "username")
                    defaults.set(user.name, forKey: "name")
                    defaults.set(user.email, forKey: "email")
                    defaults.set(user.password, forKey: "password")
                    customActivityIndicatory(self.view, startAnimate: false)
                    self.performSegue(withIdentifier: "registerSuccesfull", sender: self)
                }else{
                    customActivityIndicatory(self.view, startAnimate: false)
                    let alert = UIAlertController(title: "Register", message: "Register Failed", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.registerButton.isEnabled = true
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "registerSuccesfull"?:
            _ = segue.destination as! MenuViewController
        default:
            fatalError("Unknown segue")
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            let oldText = text as NSString
            let newText = oldText.replacingCharacters(in: range, with: string)
            if(nameField.text != "" && usernameField.text != "" && passwordField.text != "" && emailField.text != "" && self.isValidEmail(testStr: emailField.text!)){
                registerButton.isEnabled = newText.count > 0
            }
        } else {
            registerButton.isEnabled = false
        }
        return true
    }
}

