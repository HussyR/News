//
//  NewsTableViewCell.swift
//  News
//
//  Created by Данил on 05.02.2022.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    //MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(named: "backgroundColor")
        setupUI()
    }

    //MARK: setupUI
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(visitedLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            visitedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            visitedLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            visitedLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            visitedLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with article: Article) {
        titleLabel.text = article.title
        visitedLabel.text = "Visited: \(article.visited)"
    }
    
 
    
    
    //MARK: UIElements
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let visitedLabel : UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: Others
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
