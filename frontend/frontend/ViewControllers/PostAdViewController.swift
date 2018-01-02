import UIKit
import Foundation

class PostAdViewController: UITableViewController{
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    
    var zoekertje: Zoekertje?
    
    override func viewDidLoad() {
        if let zoekertje = zoekertje {
            title = "Edit Ad"
            nameField.text = zoekertje.name
            descriptionField.text = zoekertje.description
            locationField.text = zoekertje.location
            priceField.text = String(zoekertje.price)
            saveButton.isEnabled = true
        }
    }
    
    @IBAction func save() {
        saveButton.isEnabled = false
        customActivityIndicatory(self.view, startAnimate: true)
        if zoekertje != nil {
            let name = zoekertje!.name
            zoekertje?.name = nameField.text!
            zoekertje?.description = descriptionField.text
            zoekertje?.price = Int(priceField.text!)!
            zoekertje?.location = locationField.text!
            KituraService.shared.updateAd(withName: name, zoekertje: zoekertje!){(result: Bool) in
                DispatchQueue.main.async() {
                if(result){
                    self.performSegue(withIdentifier: "didEditAd", sender: self)
                    customActivityIndicatory(self.view, startAnimate: false)
                }else{
                    customActivityIndicatory(self.view, startAnimate: false)
                    let alert = UIAlertController(title: "Editing Ad", message: "Editing Your Ad Failed", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.saveButton.isEnabled = true
                    }
                }
            }
        } else {
            zoekertje = Zoekertje(name: nameField.text!, description: descriptionField.text, price: Int(priceField.text!)!, location: locationField.text!, by: User(username: UserDefaults.standard.string(forKey: "username")!, name: UserDefaults.standard.string(forKey: "name")!, email: UserDefaults.standard.string(forKey: "email")!,password: UserDefaults.standard.string(forKey: "password")!))
            KituraService.shared.add(zoekertje!){(result: Zoekertje) in
                DispatchQueue.main.async() {
                    if(result.name != ""){
                        customActivityIndicatory(self.view, startAnimate: false)
                        self.performSegue(withIdentifier: "didPostAd", sender: self)
                    }else{
                        customActivityIndicatory(self.view, startAnimate: false)
                        let alert = UIAlertController(title: "Posting Ad", message: "Posting Your Ad Failed", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.saveButton.isEnabled = true
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "didPostAd"?:
            _ = segue.destination as! MenuViewController
        case "didEditAd"?:
            _ = segue.destination as! MyAdsViewController
        default:
            fatalError("Unknown segue")
        }
    }
}

extension PostAdViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            let oldText = text as NSString
            let newText = oldText.replacingCharacters(in: range, with: string)
            if(priceField.text != "" && locationField.text != "" && nameField.text != ""){
                saveButton.isEnabled = newText.count > 0
            }
        } else {
            saveButton.isEnabled = false
        }
        if(textField == priceField){
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
        }else{
            return true
        }
    }
}
