//
//  AllChatsController.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 23.12.2022.
//

import UIKit

class NewChatController: UIViewController {
    
    public var completion: (([String: Any]) -> (Void))?
    
    private let activityIndicator = DefaultActivityIndicator(indicatorStyle: .large)
    private var users = [[String: Any]]()
    private var results = [[String: Any]]()
    private var hasFatched = false
    
    private let searchBar: UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.placeholder = "Найти чат"
        return searchBar
    }()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "result user")
       return tableView
    }()
    private let noResultLabel = DefaultUILabel(inputText: "Нет совпадений", fontSize: 21, fontWeight: .medium, alingment: .center)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noResultLabel.frame = CGRect(x: view.frame.width/4, y: (view.frame.width/4)/2, width: view.frame.width/2, height: view.frame.width/4)
    }
    
    private func setupController(){
        title = "NewChatController"
        view.backgroundColor = .systemTeal
        [noResultLabel, tableView].forEach({
            view.addSubview($0)
        })
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Отмена", style: .done, target: self, action: #selector(dismissSelf))
        searchBar.becomeFirstResponder()
        noResultLabel.isHidden = true
    }
    
    @objc func dismissSelf(){
        dismiss(animated: true)
    }
}

extension NewChatController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "result user", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = results[indexPath.row]["name"] as? String
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let targetUserData = results[indexPath.row]
        dismiss(animated: true) { [weak self] in
            self?.completion?(targetUserData)
        }
        
    }
    
}

extension NewChatController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {return}
        
        searchBar.resignFirstResponder()
        results.removeAll()
        activityIndicator.show(view: view)
        
        searchUsers(query: text)
    }
    
    func searchUsers(query: String){
        if hasFatched {
            filteredUsers(with: query)
        } else {
            DataBaseManager.shared.getAllUsers { [weak self] result in
                switch result {
                case .success(let userCollection):
                    self?.hasFatched = true
                    self?.users.append(userCollection)
                    self?.filteredUsers(with: query)
                case .failure(let error):
                    print("Failed to get users: \(error)")
                }
            }
        }
    }
    
    func filteredUsers(with term: String){
        guard hasFatched else {
            return
        }
        
        self.activityIndicator.remove()
        
        let results: [[String: Any]] = self.users.filter({
            guard let name = $0["name"] as? String else {
                return false
            }
            return name.hasPrefix(term)
        })
        self.results = results
        updateUI()
    }
    
    func updateUI() {
        if results.isEmpty {
            self.noResultLabel.isHidden = false
            self.tableView.isHidden = true
        } else {
            self.noResultLabel.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
}


// MARK: - SwiftUI
import SwiftUI
struct NewChatController_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            // Return whatever controller you want to preview
            let viewController = UINavigationController(rootViewController: NewChatController())
            return viewController
        }.edgesIgnoringSafeArea(.all)
            
    }
}
