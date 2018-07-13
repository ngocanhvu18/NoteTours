//
//  PlacesViewController.swift
//  NoteTours
//
//  Created by NgọcAnh on 7/10/18.
//  Copyright © 2018 Ngọc Anh. All rights reserved.
//

import UIKit

class RegionsViewController: UITableViewController {

    let regions: [String] = ["I. Địa điểm phượt ở miền Bắc",
                             "II. Địa điểm phượt ở miền Trung",
                             "III. Địa điểm phượt miền Nam",
                             "IV. Địa điểm phượt miền Tây"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return regions.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RegionCell
        cell.photoView.image = UIImage(named: "\(indexPath.section)\(indexPath.row+1)")
        cell.labelText.text = regions[indexPath.row]
        
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height/3
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let placesController = segue.destination as? PlacesViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            placesController?.key = regions[indexPath.row]
        }
    }
}
