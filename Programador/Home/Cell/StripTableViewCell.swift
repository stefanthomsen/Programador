//
//  StripCollectionViewCell.swift
//  Programador
//
//  Created by Stefan Thomsen on 23/05/17.
//  Copyright © 2017 Creative Dev. All rights reserved.
//

import Alamofire
import AlamofireImage
import Foundation
import UIKit

class StripTableViewCell: UITableViewCell {
    @IBOutlet weak var title:UILabel!
    @IBOutlet weak var stripImageView:UIImageView!
    
    func configureCell(with URLString: String!) {
        guard let urlString = URLString else {
            //TODO: handle blank url
            return
        }
        let size = stripImageView.frame.size
        stripImageView.af_setImage(
            withURL: URL(string: urlString)!,
            placeholderImage: nil,
            filter: AspectScaledToFitSizeFilter(size: size),
            imageTransition: .crossDissolve(0.5)
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stripImageView.af_cancelImageRequest()
        stripImageView.layer.removeAllAnimations()
        stripImageView.image = nil
    }
}
