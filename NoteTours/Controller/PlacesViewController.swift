//
//  ContentPlacesViewController.swift
//  NoteTours
//
//  Created by NgọcAnh on 7/10/18.
//  Copyright © 2018 Ngọc Anh. All rights reserved.
//

import UIKit

class PlacesViewController: UITableViewController {
    
    var key: String!
    var placesData: [Places] = []
    override func viewDidLoad() {
        super.viewDidLoad()
     
        if key != nil {
            DataService.shared.getPlacesFirst(key: key, complete: { [unowned self] (placesFirst) in
                self.placesData = placesFirst
                self.tableView.reloadData()
            })
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //        return DataService.shared.placesFirst.count
        return placesData.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlacesCell
        cell.nameLabel.text = placesData[indexPath.row].name
        cell.contentLabel.text = placesData[indexPath.row].content
        
        
        return cell
    }
    
     // MARK: - Navigation
     
   
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      let contentViewController = segue.destination as? ContentController
        if let indexPath = tableView.indexPathForSelectedRow {
            contentViewController?.places = placesData[indexPath.row]
            
        }
     }
    
    
}

