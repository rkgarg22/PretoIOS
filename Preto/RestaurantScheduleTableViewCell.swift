//
//  RestaurantScheduleTableViewCell.swift
//  Preto
//
//  Created by apple on 15/08/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class RestaurantScheduleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel:UILabel!
    @IBOutlet weak var timeLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(dict:NSDictionary) {
        dayLabel.text = (dict.value(forKey: "day") as? String ?? "") + ":"
        timeLabel.text = dict.value(forKey: "time") as? String
    }

}
