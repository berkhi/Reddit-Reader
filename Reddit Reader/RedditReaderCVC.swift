//
//  RedditReaderCVC.swift
//  Reddit Reader
//
//  Created by BerkH on 4.10.2023.
//

import UIKit

class RedditReaderCVC: UICollectionViewCell {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContainer.layer.cornerRadius = 20
        viewContainer.layer.masksToBounds = true
    }
}
