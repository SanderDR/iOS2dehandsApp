import UIKit
class AdViewController: UITableViewController {

    var ad: Zoekertje!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var byField: UITextField!
    
    override func viewDidLoad() {
        title = ad.name
        nameField.text = ad.name
        descriptionField.text = ad.description
        locationField.text = ad.location
        priceField.text = "€ " + String(ad.price)
        byField.text = ad.by.username
    }
    @IBAction func sendMail(_ sender: Any) {
        UIApplication.shared.open(URL(string: "mailto:" + ad.by.email)! as URL, options: [:], completionHandler: nil)
        print("mailto:" + ad.by.email)
    }
}
