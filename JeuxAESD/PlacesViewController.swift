//
//  PlacesViewController.swift
//  JeuxAESD
//
//  Created by Nicolas Gnyra on 17-04-05.
//  Copyright © 2017 Nicolas Gnyra. All rights reserved.
//

import UIKit

class PlacesViewController: UITableViewController {
    private var places = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APICommunication.onLocationsUpdated.addHandler(onLocationsUpdated(_:))
        
        APICommunication.loadLocations()
    }
    
    func onLocationsUpdated(_ locations: [Location]) {
        places.removeAll()
        
        for location in locations {
            if (location.type == 1 || location.type == 2) {
                places.append(location)
            }
        }
        
        places.sort(by: { (a,b) -> Bool in return a.name < b.name })
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let mapController: MapViewController = tabBarController?.viewControllers?[0].childViewControllers[0] as? MapViewController else {
            print("Failed to find MapViewController")
            return
        }
        
        mapController.selectedLocation = places[indexPath.row]
        
        tabBarController?.selectedIndex = 0
        
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlacesTableViewCell") as? PlacesTableViewCell else {
            Logger.error("Failed to dequeue cell with identifier PlacesTableViewCell")
            return UITableViewCell()
        }
        
        cell.titleLabel.text = places[indexPath.row].name
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
