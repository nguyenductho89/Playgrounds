//
//  AddButtonView.swift
//  SideApps
//
//  Created by Nguyen Duc Tho on 10/12/20.
//  Copyright © 2020 Nguyen Duc Tho. All rights reserved.
//

import UIKit

class AddButtonView: UIView {
    
    @IBOutlet var contentView: AddButtonView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("AddButtonView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func setTitle(_ title: String) {
        self.titleLabel.text = title
    }
}
