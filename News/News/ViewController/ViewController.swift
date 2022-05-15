//
//  ViewController.swift
//  News
//
//  Created by Данил on 04.02.2022.
//

import UIKit
// API KEY 55041c0635e44672a183851674e7846e

/*
 + Загружать не больше 20-ти новостей
 + Предусмотреть возможность обновлению списка новостей.
 + На каждой ячейке должен быть счетчик (число), отражающий количество переходов к просмотру деталей этой конкретной новости.
 + При нажатии на каждую новость, она должна открывать новый экран и показывать содержимое
 + Приложение должно быть написано на Swift. Без использования SwiftUI. Без использования сторонних библиотек/подов.
 + Данные о новостях (заголовок, краткое содержание, ссылка на полную версию) и счетчик просмотров необходимо кэшировать используя UserDefaults
 + Закэшированные данные отображаются перед отправлением запроса на обновление данных.
 + Закэшированные данные доступны и после перезапуска приложения.
 
 Дополнительно:
 + Постраничная загрузка всех доступных новостей (по 20 новостей).
 + Обновлять список новостей с помощью жеста pull-to-refresh.
 + Обработка исключений. Например, отсутствие интернет-соединения.
 */

final class ViewController: UIViewController {

    let cellID = "cellID"
    let networkManager = NetworkManager()
    var articles = [Article]()
    var isLoaded = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        setupNavigationBar()
        setupUI()
        if articles.isEmpty {
            fetchNextPage()
        } else {
            isLoaded = false
            networkManager.currentPage = (articles.count / 20) + 1
        }
    }

    
    //MARK: NavigationBar
    
    private func setupNavigationBar() {
        navigationItem.title = "News"
    }
    
    //MARK: setupUI
    
    private func setupUI() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK: Network logic
    
    private func fetchNextPage() {
        networkManager.fetchNextPage { [weak self] (articles, error) in
            guard let self = self else {return}
            if let error = error as? URLError,
               error.errorCode == -1020
            {
                print("hello")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Отсутсвует интернет соединение", message: "Подключите интернет и перезайдите в приложение", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                self.isLoaded = false
            }
            guard let articles = articles
            else {return}
            DispatchQueue.main.async {
                self.articles.append(contentsOf: articles)
                self.tableView.reloadData()
                self.isLoaded = false
            }
        }
        
    }
    
    //MARK: Objc actions
    
    @objc private func refresh(sender: UIRefreshControl) {
        networkManager.currentPage = 1
        networkManager.fetchNextPage { [weak self] (articles, error) in
            guard let self = self else {return}
            if let error = error as? URLError,
               error.errorCode == -1020
            {
                let alert = UIAlertController(title: "Отсутсвует интернет соединение", message: "Подключите интернет и перезайдите в приложение", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            guard let articles = articles
            else {return}
            DispatchQueue.main.async {
                self.articles = articles
                self.tableView.reloadData()
                sender.endRefreshing()
            }
        }
        
    }
    
    
    //MARK: UI Elements
    // lazy var чтобы можно было обращаться к self
    
    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(named: "backgroundColor")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.refreshControl = refreshControl
        return tableView
    }()

}
//MARK: UITableViewDataSource, UITableViewDelegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! NewsTableViewCell
        cell.accessoryType = .disclosureIndicator
        cell.configure(with: articles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        articles[index].visited += 1
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        let vc = DetailViewController()
        vc.data = articles[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//MARK: UIScrollViewDelegate постраничная загрузка PAGINATION

extension ViewController: UIScrollViewDelegate {
    
    // Будет появляться при прокрутке вниз и ожидании подгрузки данных
    private func createSpinnerFooter () -> UIView {
        let footview = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 150))
        let spinner = UIActivityIndicatorView()
        spinner.startAnimating()
        spinner.color = .black
        spinner.center = footview.center
        footview.addSubview(spinner)
        return footview
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y + scrollView.frame.size.height
        if (!isLoaded && (networkManager.currentPage <= networkManager.maxPage)) {
            if (position > scrollView.contentSize.height + 30) {
                tableView.tableFooterView = createSpinnerFooter()
                isLoaded = true
                networkManager.fetchNextPage { [weak self] (articles, error) in
                    guard let self = self else {return}
                    if let error = error as? URLError,
                       error.errorCode == -1020
                    {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Отсутсвует интернет соединение", message: "Подключите интернет и перезайдите в приложение", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            self.tableView.tableFooterView = nil
                            self.isLoaded = false
                        }
                        return
                    }
                    guard let articles = articles else {return}
                    self.articles.append(contentsOf: articles)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.tableView.tableFooterView = nil
                        self.isLoaded = false
                    }
                }
            }
        }
        
    }
}
