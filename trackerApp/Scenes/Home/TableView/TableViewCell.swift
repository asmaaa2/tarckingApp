//
//  TableViewCell.swift
//  trackerApp
//
//  Created by Asmaa on 04/08/2022.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var fbTestBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    @IBAction func fbTestBtnAction(_ sender: Any) {
       
    }
}
