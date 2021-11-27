//
//  NewsTableViewCell.swift
//  ACL
//
//  Created by Gagandeep on 27/07/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var titleImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(_ news: News) {
        // set title and name
        titleLabel.text = news.newsDescription?.string
        nameLabel.text = news.author
        if let imageName = news.image {
            titleImageView.sd_setImage(with: URL(string: imageName), placeholderImage: nil)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
