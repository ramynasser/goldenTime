//
//  FirstFlatsDetailsCell.swift
//  GoldenTime
//
//  Created by ramy nasser on 6/29/17.
//  Copyright © 2017 RamyNasser. All rights reserved.
//

import UIKit
import AwesomeButton
class FirstFlatsDetailsCell: UITableViewCell {
    var buttonDelegate: ButtonDelegate?

    @IBOutlet weak var RenterNameLabel: UILabel!
    
    @IBOutlet weak var EndDateLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var ValueLabel: UILabel!
    @IBOutlet weak var TypeLabel: UILabel!
    @IBAction func clickContract(_ sender: AnyObject) {
        if let delegate = buttonDelegate {
            delegate.cellTapped(cell: self)
        }

    }
    @IBOutlet weak var ContractButton: AwesomeButton!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
protocol ButtonDelegate {
    func cellTapped(cell: FirstFlatsDetailsCell)
}
