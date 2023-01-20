//
//  ConstantNewsApi.swift
//  MdFahimFaezAbir-30028
//
//  Created by Bjit on 18/1/23.
//

import Foundation
struct ApiCategory{
    var categoryName: String
}
extension ApiCategory{
    static let country = "us"
    static let pageSize = 20
    static let apiKey = "43afe041fe2749ac80299ccae0a51779"
    static let category = [ApiCategory(categoryName: ""),ApiCategory(categoryName: "business"), ApiCategory(categoryName: "general"),ApiCategory(categoryName: "entertainment"),ApiCategory(categoryName: "health"),ApiCategory(categoryName: "science"), ApiCategory(categoryName: "sports"),ApiCategory(categoryName: "technology")]
}

class ApiMaker{
    static let shared = ApiMaker()
    private init(){}
    func apiMaker(row: Int, page: Int)->String{
        var apiUrl = ""
        if ApiCategory.category[row].categoryName != ""{
        apiUrl = "https://newsapi.org/v2/top-headlines?country=\(ApiCategory.country)&category=\(ApiCategory.category[row].categoryName)&pageSize=\(ApiCategory.pageSize)&apiKey=\(ApiCategory.apiKey)&page=\(page)"
        }
        else{
            apiUrl = "https://newsapi.org/v2/top-headlines?country=\(ApiCategory.country)&pageSize=\(ApiCategory.pageSize)&apiKey=\(ApiCategory.apiKey)&page=\(page)"
        }
        //print(apiUrl)
        return apiUrl
    }
    
}
