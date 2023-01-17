//
//  CollectionViewCell.swift
//  MdFahimFaezAbir-30028
//
//  Created by Bjit on 12/1/23.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        uiView.layer.cornerRadius = uiView.bounds.size.width / 2.0
    }
    override func prepareForReuse() {
        uiView.layer.backgroundColor = UIColor.white.cgColor
    }
}
