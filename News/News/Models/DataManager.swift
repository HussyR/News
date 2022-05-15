//
//  DataManager.swift
//  News
//
//  Created by Данил on 05.02.2022.
//

import Foundation

/*
 Отдельно сохраняю массив посещений новостей так как Encoder не кодирует visited
 */

struct DataManager {
    
    static func saveData(articles: [Article]) {
        do {
            let data = try JSONEncoder().encode(articles)
            let visitedArray = articles.map {$0.visited}
            
            UserDefaults.standard.set(data, forKey: "articles")
            UserDefaults.standard.set(visitedArray, forKey: "visitedArray")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func loadData() -> [Article]? {
        guard let data = UserDefaults.standard.data(forKey: "articles"),
              let visitedArray = UserDefaults.standard.array(forKey: "visitedArray") as? [Int]
        else {return nil}

        do {
            var articles = try JSONDecoder().decode([Article].self, from: data)
            for (index, value) in visitedArray.enumerated() {
                articles[index].visited = value
            }
            return articles
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    
}
