//
//  ContactTableViewCell.swift
//  Simple Contact
//
//  Created by Ari Gonta on 24/04/20.
//  Copyright © 2020 Ari Gonta. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var imageContact: UIImageView! {
        didSet {
            imageContact.setRounded()
        }
    }
}
