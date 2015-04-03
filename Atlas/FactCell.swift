//
//  FactCell.swift
//  Atlas
//
//  Created by Mathew Spolin on 4/2/15.
//  Copyright (c) 2015 Automatt. All rights reserved.
//

import UIKit

class FactCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
