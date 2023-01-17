//
//  BookMarkCategoryCellCollectionViewCell.swift
//  MdFahimFaezAbir-30028
//
//  Created by Bjit on 17/1/23.
//

import UIKit

class BookMarkVcCategoryCell: UICollectionViewCell {
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var image: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        uiView.layer.cornerRadius = uiView.bounds.size.height / 2.0
        // Initialization code
    }
    override func prepareForReuse() {
        uiView.backgroundColor = .white
    }
}
