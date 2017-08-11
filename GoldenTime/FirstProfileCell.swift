//
//  FirstProfileCell.swift
//  GoldenTime
//
//  Created by ramy nasser on 6/27/17.
//  Copyright © 2017 RamyNasser. All rights reserved.
//

import UIKit
import Segmentio
import AvatarImageView

class FirstProfileCell: UITableViewCell {

    @IBOutlet weak var ProfileImage: UIImageView!
   
    @IBOutlet weak var NameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        ProfileImage.layer.borderColor = UIColor.white.cgColor
        ProfileImage.layer.borderWidth = 3

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
