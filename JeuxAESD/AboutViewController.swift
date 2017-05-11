//
//  AboutViewController.swift
//  JeuxAESD
//
//  Created by Nicolas Gnyra on 17-04-09.
//  Copyright © 2017 Nicolas Gnyra. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var cancelNotificationsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.text = "Version " + version
        }
        
        if AppDelegate.isDebugDevice {
            cancelNotificationsButton.isHidden = false
        }
    }
    
    @IBAction func cancelAllNotificationsButtonClicked(_ sender: Any) {
        NotificationHelper.cancelAll()
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
