import UIKit

class AdCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var zoekertje: Zoekertje! {
        didSet {
            nameLabel.text = zoekertje.name
            priceLabel.text = "€ " + String(zoekertje.price)
        }
    }
}

