//
//  ConstantNewsApi.swift
//  MdFahimFaezAbir-30028
//
//  Created by Bjit on 18/1/23.
//

import Foundation

struct ConstantNewsApi{
    var newsUrl: String
}
extension ConstantNewsApi{
    static let Url = [
                    ConstantNewsApi(newsUrl: "https://newsapi.org/v2/top-headlines?country=us&pageSize=20&apiKey=bff15758b4e346e5b36600845a9d4b43"),
                      ConstantNewsApi(newsUrl: "https://newsapi.org/v2/top-headlines?country=us&category=business&pageSize=20&apiKey=bff15758b4e346e5b36600845a9d4b43"),
                      ConstantNewsApi(newsUrl: "https://newsapi.org/v2/top-headlines?country=us&category=general&pageSize=20&apiKey=bff15758b4e346e5b36600845a9d4b43"),
                      ConstantNewsApi(newsUrl: "https://newsapi.org/v2/top-headlines?country=us&category=entertainment&pageSize=20&apiKey=bff15758b4e346e5b36600845a9d4b43"),
                      ConstantNewsApi(newsUrl: "https://newsapi.org/v2/top-headlines?country=us&category=health&pageSize=20&apiKey=bff15758b4e346e5b36600845a9d4b43"),
                      ConstantNewsApi(newsUrl: "https://newsapi.org/v2/top-headlines?country=us&category=science&pageSize=20&apiKey=bff15758b4e346e5b36600845a9d4b43"),
                      ConstantNewsApi(newsUrl: "https://newsapi.org/v2/top-headlines?country=us&category=sports&pageSize=20&apiKey=bff15758b4e346e5b36600845a9d4b43"),
                      ConstantNewsApi(newsUrl: "https://newsapi.org/v2/top-headlines?country=us&category=technology&pageSize=20&apiKey=bff15758b4e346e5b36600845a9d4b43")
                      
    ]
}
