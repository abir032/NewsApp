//
//  PaginationHelper.swift
//  MdFahimFaezAbir-30028
//
//  Created by Bjit on 19/1/23.
//

import Foundation
class PaginationHelper{
    static let shared = PaginationHelper()
    private init(){}
    var pageCount: [String: Int] = [
        Category.categoryList[0].categoryName : 1,
        Category.categoryList[1].categoryName : 1,
        Category.categoryList[2].categoryName : 1,
        Category.categoryList[3].categoryName : 1,
        Category.categoryList[4].categoryName : 1,
        Category.categoryList[5].categoryName : 1,
        Category.categoryList[6].categoryName : 1,
        Category.categoryList[7].categoryName : 1,
    ]
    func countPage(category: String){
        let defaults = UserDefaults.standard
        if defaults.value(forKey: "pageCounter") == nil{
            defaults.set(pageCount, forKey: "pageCounter")
        }else{
            if var page = defaults.dictionary(forKey: "pageCounter") as? [String:Int], let value = page[category] {
                page[category] = value + 1
                print(page)
                defaults.set(page, forKey: "pageCounter")
            }
        }
    }
}

