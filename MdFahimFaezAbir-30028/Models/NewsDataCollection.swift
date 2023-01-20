//
//  NewsDataCollection.swift
//  MdFahimFaezAbir-30028
//
//  Created by Bjit on 13/1/23.
//

import Foundation

class NewsDataCollection{
    static let sheared = NewsDataCollection()
    private init(){}
  
    func getJson(url: String, completion: @escaping(Result<Welcome?,Error>)->Void){
        var result: Welcome?
        guard let url = URL(string: url) else {return }
        let group = DispatchGroup()
        let urlSession = URLSession.shared
        group.enter()
        urlSession.dataTask(with: url){ data , response, error in
            if let error = error {
                print("Server Not found \(error.localizedDescription)")
            }
            else{
                guard let data = data else {
                    return
                }
                do{
                    result = try JSONDecoder().decode(
                        Welcome.self, from: data)
                    group.notify(queue: .main){
                        completion(.success(result))
                    }
                }catch{
                    group.notify(queue: .main){
                        completion(.failure(error))
                    }
                }//print(result)
                group.leave()
            }
        }.resume()
    }
    
}
