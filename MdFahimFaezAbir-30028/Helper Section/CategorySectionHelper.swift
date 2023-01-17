//
//  CategorySectionHelper.swift
//  MdFahimFaezAbir-30028
//
//  Created by Bjit on 16/1/23.
//

import Foundation

class CategorySectionHelper{
    static let shared = CategorySectionHelper()
    private init(){}
    
    func selectCategory(category: String)-> [NewsDB]?{
        var result = [NewsDB]()
        if let news = CoreDataDB.shared.getAllNews(category: category){
            result = news
       }
       return result
    }
    func selectCategoryForBoomark(category: String)-> [BookMark]?{
        var result = [BookMark]()
        if let news = CoreDataDBBookMark.shared.getAllUser(category: category){
            result = news
        }
        return result
    }
    
}
