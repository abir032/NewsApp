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
        let task = URLSession.shared.dataTask(with: url){ data , response, error in
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
                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                }//print(result)
            }
        }
        task.resume()
    }
    
}
