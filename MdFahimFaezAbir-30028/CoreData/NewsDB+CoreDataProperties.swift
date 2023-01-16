//
//  NewsDB+CoreDataProperties.swift
//  MdFahimFaezAbir-30028
//
//  Created by Bjit on 13/1/23.
//
//

import Foundation
import CoreData


extension NewsDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsDB> {
        return NSFetchRequest<NewsDB>(entityName: "NewsDB")
    }

    @NSManaged public var author: String?
    @NSManaged public var category: String?
    @NSManaged public var content: String?
    @NSManaged public var newsDescription: String?
    @NSManaged public var publishedAt: String?
    @NSManaged public var sourceName: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?

}

extension NewsDB : Identifiable {

}
