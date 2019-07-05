//
//  ContactListCustomCell.swift
//  MyContactApp
//
//  Created by SourabhMehta on 21/06/19.
//  Copyright © 2019 Sourabh. All rights reserved.
//

import UIKit

class ContactListCustomCell: UITableViewCell {

    @IBOutlet weak var contactPhotoView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactFavouriteImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contactPhotoView.layer.cornerRadius = contactPhotoView.frame.size.height/2
        contactPhotoView.clipsToBounds = true
        contactNameLabel.textColor = Constants.Color.contactLabelColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
