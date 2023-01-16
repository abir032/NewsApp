//
//  NewsCollectionViewCell.swift
//  MdFahimFaezAbir-30028
//
//  Created by Bjit on 14/1/23.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var catgory: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        newsImage.layer.cornerRadius = 10
    }

    @IBOutlet weak var publishDate: UILabel!
    @IBOutlet weak var source: UILabel!
}
