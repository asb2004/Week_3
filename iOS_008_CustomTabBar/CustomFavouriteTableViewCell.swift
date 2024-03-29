//
//  CustomFavouriteTableViewCell.swift
//  iOS_008_CustomTabBar
//
//  Created by DREAMWORLD on 29/02/24.
//

import UIKit

class CustomFavouriteTableViewCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    @IBOutlet var profileImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
