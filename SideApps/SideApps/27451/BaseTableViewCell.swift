//
//  BaseTableViewCell.swift
//  SideApps
//
//  Created by Nguyen Duc Tho on 10/7/20.
//  Copyright © 2020 Nguyen Duc Tho. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

class ASubclassBaseTableViewCell: BaseTableViewCell {
    override func awakeFromNib() {
        self.titleLabel.backgroundColor = .red
    }
}
