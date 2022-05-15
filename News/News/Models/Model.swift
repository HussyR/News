//
//  Model.swift
//  News
//
//  Created by Данил on 05.02.2022.
//

import Foundation
import UIKit
// MARK: - PageWithNews
struct Page: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    var visited: Int = 0 // visited
    let source: Source
    let author: String?
    let title, articleDescription: String
    let url: String
    let urlToImage: String
    let publishedAt: String
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
}
// MARK: - Source
struct Source: Codable {
    let name: String
}
