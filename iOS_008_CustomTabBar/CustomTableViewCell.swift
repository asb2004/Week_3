//
//  CustomTableViewCell.swift
//  iOS_008_CustomTabBar
//
//  Created by DREAMWORLD on 28/02/24.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var nameText: UILabel!
    @IBOutlet var favButton: UIButton!
    
    var id: Int = 0
    var isFav: Int = 0
    var db: DBhelper!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImage.layer.cornerRadius = profileImage.frame.width / 2

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    @IBAction func favButtonTapped(_ sender: UIButton) {
        if isFav == 1{
            favButton.setImage(UIImage(systemName: "heart"), for: .normal)
            isFav = 0
            db.updateFavourie(id: id, favourite: 0)
        } else {
            favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            isFav = 1
            db.updateFavourie(id: id, favourite: 1)
        }
    }
}
