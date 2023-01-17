//
//  BookMarkCell.swift
//  MdFahimFaezAbir-30028
//
//  Created by Bjit on 17/1/23.
//

import UIKit

class BookMarkCell: UITableViewCell {

    @IBOutlet weak var newsImage: UIImageView!
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var category: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        newsImage.layer.cornerRadius = 20
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
