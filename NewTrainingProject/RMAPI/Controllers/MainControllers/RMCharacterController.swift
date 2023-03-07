//
//  RMCharacterController.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 18.01.2023.
//

import UIKit

class RMCharacterController: UIViewController, RMCharacterListViewDelegate {
    
    private var characterListView = RMCharacterListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setConstraints()
        addSearchButton()
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        let searchController = RMSearchController(config: .init(type: .character))
        searchController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(searchController, animated: true)
    }
    
    @objc private func didTapSearchPopover() {
        let viewController = RMSearchController(config: RMSearchController.Config(type: .character))
        viewController.modalPresentationStyle = .popover
        viewController.navigationItem.largeTitleDisplayMode = .never
        
        guard let view = navigationItem.rightBarButtonItem!.value(forKey: "view") as? UIView else { return }
        
        if let popoverPresentationController = viewController.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = .up
            popoverPresentationController.sourceView = view
            popoverPresentationController.sourceRect = view.frame
            popoverPresentationController.delegate = self
        }
        present(viewController, animated: true, completion: nil)
    }
    
    private func setupController() {
        view.backgroundColor = .systemBackground
        title = "Characters"
        view.addSubview(characterListView)
        characterListView.delegate = self
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    //MARK: - RMCharacterListViewDelegate
    func rmCharacterListView(_ characterListView: RMCharacterListView, didSelectCharacter character: RMCharacter) {
        let viewModel = RMCharacterDetailViewViewModel(character: character)
        let detailVC = RMCharacterDetailController(viewModel: viewModel)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension RMCharacterController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
