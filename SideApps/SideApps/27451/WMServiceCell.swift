//
//  WMServiceCell.swift
//  SideApps
//
//  Created by Nguyen Duc Tho on 9/10/20.
//  Copyright © 2020 Nguyen Duc Tho. All rights reserved.
//

import UIKit

class WMServiceCell: UITableViewCell {

    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var selectImageView: UIImageView!
    @IBOutlet weak var horizontalStackView: UIStackView!
    private var urlTextfield: UITextField?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        guard selected else {
            self.selectImageView.backgroundColor = .clear
            return
        }
        //S
        self.selectImageView.backgroundColor = .red
        
    }
    
}
