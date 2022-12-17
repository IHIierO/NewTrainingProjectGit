//
//  MenuView.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 16.12.2022.
//

import UIKit

enum SideMenuItem: String, CaseIterable {
    case home = "Home"
    case settings = "Settings"
    case chatBot = "ChatBot"
}


class MenuView: UIView {
    public var delegate: MenuViewDelegate?
    private let menuName: [SideMenuItem]
    lazy var width: CGFloat = self.frame.width * 0.2
    lazy var userAvatar: UIImageView = {
        let userAvatar = UIImageView(frame: .init(x: 0, y: 0, width: self.width, height: self.width))
        userAvatar.backgroundColor = .red
        userAvatar.layer.cornerRadius = userAvatar.frame.width / 2
        userAvatar.translatesAutoresizingMaskIntoConstraints = false
        return userAvatar
    }()
    var userName = DefaultUILabel(inputText: "Artem Vorobev", fontSize: 18, fontWeight: .regular, alingment: .left)
    var tableView = UITableView()
    
    init(with title: [SideMenuItem]) {
        self.menuName = title
        super.init(frame: .zero)
        setupMenuView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMenuView(){
        self.backgroundColor = .lightGray
        self.frame = UIScreen.main.bounds
        [userAvatar, userName, tableView].forEach {
            self.addSubview($0)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "menuCell")
    }
    
    private func setConstraints(){
        NSLayoutConstraint.activate([
            userAvatar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            userAvatar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            userAvatar.widthAnchor.constraint(equalToConstant: self.width),
            userAvatar.heightAnchor.constraint(equalToConstant: self.width),
            
            userName.topAnchor.constraint(equalTo: userAvatar.topAnchor),
            userName.leadingAnchor.constraint(equalTo: userAvatar.trailingAnchor, constant: 10),
            userName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            userName.heightAnchor.constraint(equalToConstant: self.width),
            
            tableView.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension MenuView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SideMenuItem.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = menuName[indexPath.row].rawValue
        cell.contentConfiguration = content
        cell.backgroundColor = .clear
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let didSelectMenu = menuName[indexPath.row]
        delegate?.didSelectMenuIdem(named: didSelectMenu)
    }
}

// MARK: - SwiftUI
import SwiftUI
struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        ViewPreview{
            let view = MenuView(with: SideMenuItem.allCases)
            return view
        }.ignoresSafeArea(.all)
    }
}

