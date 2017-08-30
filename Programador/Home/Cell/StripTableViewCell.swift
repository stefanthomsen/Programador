//
//  StripCollectionViewCell.swift
//  Programador
//
//  Created by Stefan Thomsen on 23/05/17.
//  Copyright © 2017 Creative Dev. All rights reserved.
//


import Foundation
import UIKit

class StripTableViewCell: UITableViewCell {
    var strip:Strip? = nil
    @IBOutlet weak var title:UILabel!
    @IBOutlet weak var pubDate:UILabel!
    @IBOutlet weak var stripImageView:UIImageView!
    @IBOutlet weak var containerView:UIView!
    @IBOutlet weak var shareButton:ShareButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.white.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stripImageView.layer.removeAllAnimations()
        stripImageView.image = nil
    }
        
}
