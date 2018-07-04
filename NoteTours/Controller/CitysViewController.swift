//
//  DistrictsViewController.swift
//  NoteTours
//
//  Created by Ngọc Anh on 6/28/18.
//  Copyright © 2018 Ngọc Anh. All rights reserved.
//

import UIKit

class CitysViewController: UITableViewController, UISearchBarDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    var dataCitys: [City] = []
    override func viewDidLoad() {
        super.viewDidLoad()
         searchBar.showsCancelButton = true
        dataCitys = DataService.shared.cities
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataService.shared.cityCode = nil
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataCitys.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "city", for: indexPath)
        cell.textLabel?.text = dataCitys[indexPath.row].name
        // Configure the cell...
        
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DataService.shared.cityCode = DataService.shared.cities[indexPath.row].cityCode
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dataCitys = searchText.isEmpty ? DataService.shared.cities : DataService.shared.cities.filter({ (city: City) -> Bool in
//            return city.name.lowercased().contains(searchText.lowercased())
            return (city.name.range(of: searchText, options: .diacriticInsensitive, range: nil, locale: nil) != nil) 
        })
        
        tableView.reloadData()
    }
    
}
