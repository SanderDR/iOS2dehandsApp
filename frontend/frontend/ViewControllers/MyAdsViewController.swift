import UIKit
class MyAdsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var ads: [Zoekertje] = []
    private var indexPathToEdit: IndexPath!
    
    override func viewDidLoad() {
        customActivityIndicatory(self.view, startAnimate: true)
        KituraService.shared.myAds(){ (ads: [Zoekertje]) in
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
        case "editAd"?:
            let postAdViewController = segue.destination as! PostAdViewController
            postAdViewController.zoekertje = ads[indexPathToEdit.row]
        default:
            break
        }
    }
    
    @IBAction func unwindFromPostAd(_ segue: UIStoryboardSegue) {
        switch segue.identifier {
        case "didEditAd"?:
            tableView.reloadRows(at: [indexPathToEdit], with: .automatic)
        default:
            fatalError("Unkown segue")
        }
        
    }
    
}

extension MyAdsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") {
            (action, view, completionHandler) in
            self.indexPathToEdit = indexPath
            self.performSegue(withIdentifier: "editAd", sender: self)
            completionHandler(true)
        }
        editAction.backgroundColor = UIColor.orange
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            (action, view, completionHandler) in
            let zoekertje = self.ads.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            KituraService.shared.remove(zoekertje: zoekertje){(result: Bool) in
                completionHandler(result)
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}

extension MyAdsViewController: UITableViewDataSource {
    
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

