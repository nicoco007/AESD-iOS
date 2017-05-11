//
//  ActivitiesTableViewCell.swift
//  JeuxAESD
//
//  Created by Nicolas Gnyra on 17-04-08.
//  Copyright © 2017 Nicolas Gnyra. All rights reserved.
//

import UIKit

class ActivitiesTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var resultsImageView: UIImageView!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    var activity: Activity!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
