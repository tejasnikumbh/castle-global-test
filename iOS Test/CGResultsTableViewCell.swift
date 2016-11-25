//
//  ResultsTableViewCell.swift
//  iOS Test
//
//  Created by Tejas  Nikumbh on 25/11/16.
//  Copyright © 2016 Castle. All rights reserved.
//

import UIKit

class CGResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var thumbnailLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var thumbnailWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
