//
//  notificationCell.swift
//  GoldenTime
//
//  Created by ramy nasser on 6/20/17.
//  Copyright © 2017 RamyNasser. All rights reserved.
//

import UIKit

class notificationCell: UITableViewCell {

    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var SecondVerticalView: UIView!
    @IBOutlet weak var FirstVerticalView: UIView!
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        MainView.layer.cornerRadius = 5.0
        
       



        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
