//
//  TableViewCell.swift
//  trackerApp
//
//  Created by Asmaa on 04/08/2022.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var textTripLbl: UILabel!
    
    @IBOutlet weak var numberOfTrip: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
