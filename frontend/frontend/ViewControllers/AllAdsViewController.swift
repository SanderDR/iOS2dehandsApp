import UIKit
class AllAdsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var ads: [Zoekertje] = []
    
    override func viewDidLoad() {
        customActivityIndicatory(self.view, startAnimate: true)
        KituraService.shared.getAds(){ (ads: [Zoekertje]) in
            DispatchQueue.main.async() {
                self.ads = ads
                self.tableView.reloadData()
                customActivityIndicatory(self.view, startAnimate: false)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch  segue.identifier {
        case "showAd"?:
            let AdViewController = segue.destination as! AdViewController
            let selection = tableView.indexPathForSelectedRow!
            AdViewController.ad = ads[selection.row]
            tableView.deselectRow(at: selection, animated: true)
        default:
            break
        }
    }
    
}
extension AllAdsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adCell", for: indexPath) as! AdCell
        cell.zoekertje = ads[indexPath.row]
        return cell
    }
}
