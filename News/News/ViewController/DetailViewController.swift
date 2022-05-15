//
//  DetailViewController.swift
//  News
//
//  Created by Данил on 05.02.2022.
//

import UIKit

final class DetailViewController: UIViewController {

    var data: Article?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        setupUI()
        configure()
        navigationController?.navigationBar.prefersLargeTitles = false
        checkAllButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    //MARK: Configure
    
    private func configure() {
        guard let data = data else {return}
        NetworkManager.fetchImage(url: data.urlToImage) {[weak self] data in
            guard let self = self else {return}
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else {return}
                self.imageView.image = image
            }
        }
        titleLabel.text = data.title
        detailView[0].systemLabel.text = "Author:"
        detailView[0].customLabel.text = data.author
        
        detailView[1].systemLabel.text = "Source:"
        detailView[1].customLabel.text = data.source.name
        
        detailView[2].systemLabel.text = "Data:"
        detailView[2].customLabel.text = data.publishedAt
        
        contentLabel.text = data.content
        
        
    }
    
    //MARK: Открыть полную статью
    @objc private func tapped() {
        guard let url = URL(string: data?.url ?? "") else {return}
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
    //MARK: setupUI
    private func setupUI () {
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 200),
            scrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.frameLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailView[0])
        contentView.addSubview(detailView[1])
        contentView.addSubview(detailView[2])
        contentView.addSubview(contentLabel)
        contentView.addSubview(checkAllButton)
        
        
        // НАстройки контента  scrollView
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            detailView[0].topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            detailView[0].leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            detailView[0].trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            detailView[1].topAnchor.constraint(equalTo: detailView[0].bottomAnchor, constant: 10),
            detailView[1].leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            detailView[1].trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            detailView[2].topAnchor.constraint(equalTo: detailView[1].bottomAnchor, constant: 10),
            detailView[2].leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            detailView[2].trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            contentLabel.topAnchor.constraint(equalTo: detailView[2].bottomAnchor, constant: 10),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            checkAllButton.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 10),
            checkAllButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            checkAllButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)

        ])
        
        
    }
    
    //MARK: UIElements
    // Автор
    // Название
    // Текст статьи
    // Дата
    // Источник
    
    // Каждая содержит два label, которые далее будут конфигурироваться
    // Автор
    // Дата
    // Источник
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "backgroundColor")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let detailView : [DetailView] = {
        var views = [DetailView]()
        for i in 0...2 {
            let view = DetailView()
            view.translatesAutoresizingMaskIntoConstraints = false
            views.append(view)
        }
        
        return views
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor(named: "textColorSet")
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let contentLabel : UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor(named: "textColorSet")
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.backgroundColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let checkAllButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Check full article", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
}
