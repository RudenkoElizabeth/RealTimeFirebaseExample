//
//  TableViewCell.swift
//  RealTimeFirebaseExample
//
//  Created by Elizabeth Rudenko on 17.09.2018.
//  Copyright © 2018 Elizabeth Rudenko. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        descriptionLabel.text = nil
    }
}
