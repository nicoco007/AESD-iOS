//
//  ActivityInfoViewController.swift
//  JeuxAESD
//
//  Created by Nicolas Gnyra on 17-04-08.
//  Copyright © 2017 Nicolas Gnyra. All rights reserved.
//

import UIKit
import Darwin

class ActivityInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var setAlarmButton: UIButton!
    var activity: Activity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard activity != nil else {
            return
        }
        
        navigationItem.title = activity.text
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH'h'mm"
        
        hoursLabel.text = "De " + dateFormatter.string(from: activity.startTime) + " à " + dateFormatter.string(from: activity.endTime)
        
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        
        resultsTableView.alwaysBounceVertical = false
        
        resultsTableView.rowHeight = UITableViewAutomaticDimension
        resultsTableView.estimatedRowHeight = 44
    }
    
    override func viewWillAppear(_ animated: Bool) {
        displayNotificationScheduledFor()
    }
    
    func getNotificationHash() -> String {
        return String(activity.text.hashValue)
    }
    
    func displayNotificationScheduledFor() {
        Logger.debug("Attempting to display activity schedule")
        
        if (activity.endTime < Date()) {
            setAlarmButton.setTitle("L'activité est terminée", for: .normal)
            setAlarmButton.isEnabled = false
            return
        }
        
        if (activity.startTime < Date()) {
            setAlarmButton.setTitle("L'activité a déjà débuté", for: .normal)
            setAlarmButton.isEnabled = false
            return
        }
        
        setAlarmButton.isEnabled = true
        
        guard let notification = NotificationHelper.get(id: getNotificationHash()) else {
            setAlarmButton.setTitle("Définir une alarme...", for: .normal)
            return
        }
        
        guard let fireDate = notification.fireDate else {
            setAlarmButton.setTitle("Définir une alarme...", for: .normal)
            return
        }
        
        let time = Int(round(activity.startTime.timeIntervalSince(fireDate) / 60))
        
        setAlarmButton.setTitle("Alarme définie : \(time) minutes. Modifier...", for: .normal)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSections = 0
        
        if activity.results.count > 0 {
            numberOfSections = 1
            tableView.backgroundView = nil
        } else {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 20))
            
            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            
            noDataLabel.text = "Aucun résultat publié."
            noDataLabel.textColor = .black
            noDataLabel.textAlignment = .center
            noDataLabel.font = UILabel().font.withSize(12)
            
            containerView.addSubview(noDataLabel)
            
            containerView.addConstraint(NSLayoutConstraint(item: noDataLabel, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1.0, constant: 8.0))
            
            tableView.backgroundView = containerView
        }
        
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activity.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsCell") as? ResultsTableViewCell else {
            Logger.error("Failed to dequeue cell with identifier ResultsCell")
            return UITableViewCell()
        }
        
        let result = activity.results[indexPath.row]
        
        cell.nameLabel.text = result.type.name
        cell.detailLabel.text = result.school.name
        
        return cell
    }
    
    @IBAction func showOnMapButtonPressed(_ sender: Any) {
        guard let mapController: MapViewController = tabBarController?.viewControllers?[0].childViewControllers[0] as? MapViewController else {
            print("Failed to find MapViewController")
            return
        }
        
        mapController.selectedLocation = activity?.parentLocation
        
        tabBarController?.selectedIndex = 0
        
        navigationController?.popViewController(animated: false)
    }

    @IBAction func createAlarmButtonPressed(_ sender: Any) {
        let exists = NotificationHelper.get(id: getNotificationHash()) != nil
        
        MessageHelper.showAlertWithPicker(self, ["5 minutes", "10 minutes", "15 minutes", "30 minutes"], "Créer une alarme", cancelButtonText: exists ? "Supprimer l'alarme" : "Annuler") { (index) -> Void in
            var timeout: Double
            
            if (index != nil) {
                switch index! {
                case 0:
                    timeout = 5
                case 1:
                    timeout = 10
                case 2:
                    timeout = 15
                case 3:
                    timeout = 30
                default:
                    timeout = 0
                }
            } else {
                timeout = 0
            }
            
            if (timeout == 0) {
                NotificationHelper.cancel(id: self.getNotificationHash())
            } else {
                let text = "\(self.activity.text) débute dans \(Int(timeout)) minutes!"
                    
                if !NotificationHelper.schedule(id: self.getNotificationHash(), message: text, triggerAt: self.activity.startTime.addingTimeInterval(-timeout * 60)) {
                    MessageHelper.showAlert(self, "Impossible de créer une alarme", "Vous avez désactivé les notifications pour cette application. Veuillez vérifier vos paramètres.")
                }
            }
                
            self.displayNotificationScheduledFor()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
