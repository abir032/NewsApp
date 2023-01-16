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

//    func deletePost(indexPath: IndexPath, postList: [Userpost]) {
//        let post = postList[indexPath.row]
//        context.delete(post)
//        do{
//            try context.save()
//        }catch{
//            print(error)
//        }
//    }
//    func updatePost(indexPath: Int, postList: [Userpost]){
//        let post = postList[indexPath]
//        do{
//            try context.save()
//        }catch{
//            print(error)
//        }
//    }
}
