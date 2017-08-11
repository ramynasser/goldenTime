//
//  SecondProfileCell.swift
//  GoldenTime
//
//  Created by ramy nasser on 6/27/17.
//  Copyright © 2017 RamyNasser. All rights reserved.
//

import UIKit

class SecondProfileCell: UITableViewCell {
    var ProfileDelegate: SecondProfileDelegate?

    @IBOutlet weak var phoneVerified: UIImageView!
    @IBOutlet weak var emailVerified: UIImageView!
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var MobileLabel: UIButton!
    @IBOutlet weak var TeleLabel: UILabel!
    @IBAction func MakeRequest(_ sender: AnyObject) {
        if let delegate = ProfileDelegate{
            delegate.cellTapped(cell: self)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
protocol SecondProfileDelegate {
    func cellTapped(cell: SecondProfileCell)
}
