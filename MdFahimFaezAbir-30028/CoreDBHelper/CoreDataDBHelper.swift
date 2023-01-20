//
//  CoreDataDBHelper.swift
//  MdFahimFaezAbir-30028
//
//  Created by Bjit on 13/1/23.
//

import Foundation
import UIKit
import CoreData

class CoreDataDB{
    static let shared = CoreDataDB()
    private init(){}
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    func checkDB(article: NewsData,category: String)-> Bool{
        let fetchRequest = NSFetchRequest<NewsDB>(entityName: "NewsDB")
        let predicate = NSPredicate(format: "category == %@ AND url == %@", category,article.url)
        fetchRequest.predicate = predicate
        do{
            let news = try context.fetch(fetchRequest)
            //print(news)
            if news.count == 0{
                print("\(category) : \(news.count)")
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
    func savePost(article: NewsData){
        print(article.author)
        let news = NewsDB(context: context)
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
    func getAllNews(category: String)-> [NewsDB]?{
        var news = [NewsDB]()
        let fetchRequest = NSFetchRequest<NewsDB>(entityName: "NewsDB")
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
    func searchNews(category: String, searchText: String)-> [NewsDB]? {
        var news = [NewsDB]()
        let fetchRequest = NSFetchRequest<NewsDB>(entityName: "NewsDB")
        let predicate = NSPredicate(format: "category == %@ AND (title CONTAINS %@ OR sourceName CONTAINS %@ OR author CONTAINS %@)",category,searchText,searchText,searchText)
        if searchText != " "{
            fetchRequest.predicate = predicate
        }
        do{
            news = try context.fetch(fetchRequest)
            // print(news[0].sourceName)
            return news
        }catch{
            print(error)
            return nil
        }
    }
    func deleteCached(category: String) {
        let fetchRequest = NSFetchRequest<NewsDB>(entityName: "NewsDB")
        let predicate = NSPredicate(format: "category == %@", category)
        fetchRequest.predicate = predicate
        do{
            let newsDB = try context.fetch(fetchRequest)
            for news in newsDB{
                context.delete(news)
            }
        }catch{
            print(error)
            
        }
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
}
