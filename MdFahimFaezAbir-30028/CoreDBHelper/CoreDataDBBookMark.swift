//
//  CoreDataDBFeedBack.swift
//  MdFahimFaezAbir-30028
//
//  Created by Bjit on 13/1/23.
//

import Foundation
import UIKit
import CoreData

class CoreDataDBBookMark{

    static let shared = CoreDataDBBookMark()
    private init(){}
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    func checkDB(article: NewsData)-> Bool{
        let fetchRequest = NSFetchRequest<BookMark>(entityName: "BookMark")
        
        let predicate = NSPredicate(format: "url == %@", article.url)
        fetchRequest.predicate = predicate
        do{
            let news = try context.fetch(fetchRequest)
            //print(news)
            if news.count == 0{
                return true
            }
            else {
                return false
            }
        }catch{
            print(error)
            return false
        }
    }
    
    func addBookmark(article: NewsData){
        print(article.author)
        let news = BookMark(context: context)
        news.category = article.category
        news.title = article.title
        news.sourceName = article.sourceName
        news.newsDescription = article.newsDescription
        news.content = article.content
        news.url = article.url
        news.urlToImage = article.urlToImage
        news.publishedAt = article.publishedAt
        news.author = article.author
        //print(news.author)
        do {
            try context.save()
            print("Save")
        }catch {
            print(error)
        }
    }
    func getAllUser(category: String)-> [BookMark]?{
        var news = [BookMark]()
        let fetchRequest = NSFetchRequest<BookMark>(entityName: "BookMark")
        let predicate = NSPredicate(format: "category == %@", category)
        fetchRequest.predicate = predicate
        do{
            news = try context.fetch(fetchRequest)
            return news
        }catch{
            print(error)
            return nil
        }
    }


}