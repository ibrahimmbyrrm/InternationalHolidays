//
//  ViewController.swift
//  International-Holidays
//
//  Created by İbrahim Bayram on 31.01.2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var holidayList = [HolidayDetail]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationItem.title = "\(self.holidayList.count) holidays found."
                self.navigationItem.prompt = "Click on holiday for more detail."
            }
        }
    }
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.prompt = "Let's learn what is the holidays of this year!"
        self.navigationItem.title = "International Holidays"
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return holidayList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CellView
        let holiday = holidayList[indexPath.row]
        cell.titleLabel.text = holiday.name
        cell.subtitleLabel.text = holiday.date.iso
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let holiday = holidayList[indexPath.row]
        let alert = UIAlertController(title: holiday.name, message: holiday.description, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}
extension ViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {return}
        let request = HolidayRequest(countryCode: searchText)
        request.getData { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let holidays):
                self?.holidayList = holidays
            }
        }
    }
    
}

