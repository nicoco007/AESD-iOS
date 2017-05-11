//
//  ActivitiesTableViewController.swift
//  JeuxAESD
//
//  Created by Nicolas Gnyra on 17-04-09.
//  Copyright © 2017 Nicolas Gnyra. All rights reserved.
//

import Foundation
import UIKit

class ActivitiesTableViewController: UITableViewController, UISearchResultsUpdating {
    private var activities: [Activity] = [Activity]()
    private var filteredActivities: [Activity] = [Activity]()
    
    private var searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 62
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(self.refreshControlValueChanged(sender:)), for: .valueChanged)
        
        self.refreshControl = refreshControl
        
        self.searchController.searchResultsUpdater = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar
        
        APICommunication.onLocationsUpdated.addHandler({ (locations) -> Void in
            self.onLocationsUpdated(locations)
        })
        
        onLocationsUpdated(APICommunication.locations)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        Logger.info("Updating search results")
        
        filterActivities()
    }
    
    func refreshControlValueChanged(sender: Any?) {
        reloadActivities()
    }
    
    func reloadActivities() {
        Logger.info("Reloading activities")
        
        APICommunication.loadLocations(forceRefresh: true)
    }
    
    func onLocationsUpdated(_ locations: [Location]) {
        var activities = [Activity]()
        
        for location in locations {
            for activity in location.activities {
                activities.append(activity)
            }
        }
        
        activities.sort(by: { (a, b) -> Bool in a.text.lowercased() < b.text.lowercased() })
        
        self.activities = activities
        
        self.filterActivities()
        
        self.refreshControl?.endRefreshing()
        
        Logger.info("Loaded activities")
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func filterActivities() {
        Logger.info("Filtering activities")
        
        filteredActivities.removeAll()
        
        if searchController.searchBar.text == nil || searchController.searchBar.text!.isEmpty {
            filteredActivities = activities
        } else {
            for activity: Activity in activities {
                Logger.verbose("Filtering activity \(activity.text)")
                
                for str in searchController.searchBar.text!.components(separatedBy: " ") {
                    Logger.verbose("Filter string: \(str)")
                    
                    if activity.text.lowercased().contains(str.lowercased()) && !filteredActivities.contains(activity) {
                        Logger.verbose("Adding activity to filtered activities")
                        
                        filteredActivities.append(activity)
                    }
                }
            }
        }
        
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredActivities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "ActivitiesTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? ActivitiesTableViewCell else {
            fatalError("The dequeued cell is not an instance of ActivitiesTableViewCell.")
        }
        
        // fetches the appropriate activity for the data source layout
        let activity = filteredActivities[indexPath.row]
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH'h'mm"
        
        cell.titleLabel.text = activity.text
        cell.hoursLabel.text = dateFormatter.string(from: activity.startTime) + " à " + dateFormatter.string(from: activity.endTime)
        cell.activity = activity
        
        if activity.results.count > 0 {
            cell.widthConstraint.constant = 48
        } else {
            cell.widthConstraint.constant = 0
        }
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        Logger.info("Preparing for segue '\(String(describing: segue.identifier))'")
        
        if segue.identifier == "showActivityInfo" {
            Logger.info("Showing activity information")
            
            guard let toViewController = segue.destination as? ActivityInfoViewController else {
                Logger.warn("Expected destination view controller to be ActivityInfoViewController, got \(segue.destination)")
                return
            }
            
            guard let tableCell = sender as? ActivitiesTableViewCell else {
                Logger.warn("Expected sender to be ActivitiesTableViewCell, got \(String(describing: sender))")
                return
            }
            
            toViewController.activity = tableCell.activity
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
