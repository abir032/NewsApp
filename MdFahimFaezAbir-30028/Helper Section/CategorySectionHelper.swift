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
    
    func selectCategory(category: String, indexPath: IndexPath)-> [NewsDB]?{
        var result = [NewsDB]()
        if indexPath.row == 0{
            if let news = CoreDataDB.shared.getAllNews(category: category){
                result = news
            }
           return result
        }
        else if indexPath.row == 1{
            if let news = CoreDataDB.shared.getAllNews(category: category){
                result = news
            }
           return result
        }
        else if indexPath.row == 2{
            if let news = CoreDataDB.shared.getAllNews(category: category){
                result = news
            }
           return result
        }
        else if indexPath.row == 3{
            if let news = CoreDataDB.shared.getAllNews(category: category){
                result = news
            }
           return result
        }
        else if indexPath.row == 4{
            if let news = CoreDataDB.shared.getAllNews(category: category){
                result = news
            }
           return result
        }
        else if indexPath.row == 5{
            if let news = CoreDataDB.shared.getAllNews(category: category){
                result = news
            }
           return result
        }
        else if indexPath.row == 6{
            if let news = CoreDataDB.shared.getAllNews(category: category){
                result = news
            }
           return result
        }
        else if indexPath.row == 7{
            if let news = CoreDataDB.shared.getAllNews(category: category){
                result = news
            }
           return result
        }else {
            if let news = CoreDataDB.shared.getAllNews(category: category){
                result = news
            }
           return result
        }
    }
    
}
