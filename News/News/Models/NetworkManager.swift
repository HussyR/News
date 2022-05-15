//
//  NetworkManager.swift
//  News
//
//  Created by Данил on 05.02.2022.
//

import Foundation

class NetworkManager {
    
    let source = "https://newsapi.org/v2/everything"
    let apiKey = "55041c0635e44672a183851674e7846e"
    let topic = "cats"
    var currentPage = 1
    let maxPage = 5
    let countOfNewsInPage = 20
    
    func fetchNextPage(completion: @escaping ([Article]?, Error?) -> Void) {
        print("download")
        guard currentPage <= maxPage else {return}
        
        if var urlComponents = URLComponents(string: source) {
            urlComponents.query = "page=\(currentPage)&pagesize=\(countOfNewsInPage)&q=\(topic)&apiKey=\(apiKey)"
            guard let url = urlComponents.url else {return}
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                guard let self = self,
                      let data = data,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200
                else {return}
                do {
                    let page = try JSONDecoder().decode(Page.self, from: data)
                    completion(page.articles, nil)
                    self.currentPage += 1
                } catch {
                    print(error.localizedDescription)
                }
                
            }.resume()
        }
        
    }
    
    static func fetchImage(url: String, completion: @escaping (Data) -> Void) {
        guard let url = URL(string: url) else {return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data
            else {return}
            completion(data)
        }.resume()
    }
    
    
}
