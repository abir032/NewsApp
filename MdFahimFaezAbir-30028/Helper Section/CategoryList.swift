//
//  CategoryList.swift
//  MdFahimFaezAbir-30028
//
//  Created by Bjit on 12/1/23.
//

import Foundation

struct Category{
    var categoryName: String
    var image: String
}
extension Category{
    static let categoryList = [Category(categoryName: "All", image: "newspaper"),
                               Category(categoryName: "Business", image: "accounting"),
                               Category(categoryName: "General", image: "world-news (1)"),
                               Category(categoryName: "Entertainment", image: "Daco_4873904"),
                               Category(categoryName: "Health", image: "Health"),
                               Category(categoryName: "Science", image: "Science"),
                               Category(categoryName: "Sports", image: "sports"),
                               Category(categoryName: "Technology", image: "technology"),
    ]
}
