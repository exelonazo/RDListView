//
//  ListCell.swift
//  ListViews
//
//  Created by Everis on 04-09-17.
//  Copyright © 2017 Felipe. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

    @IBOutlet weak var storyTitleLabel: UILabel!
    @IBOutlet weak var authorCreatedAt: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
