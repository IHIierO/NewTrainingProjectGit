//
//  RMLocationTableViewCell.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 15.02.2023.
//

import UIKit

final class RMLocationTableViewCell: UITableViewCell {
    static let cellIdentifier = "RMLocationTableViewCell"
    
    private let nameLabel = DefaultUILabel(inputText: "", fontSize: 20, fontWeight: .medium, alingment: .natural)
    private let typeLabel = DefaultUILabel(inputText: "", fontSize: 15, fontWeight: .regular, alingment: .natural)
    private let dimensionLabel = DefaultUILabel(inputText: "", fontSize: 15, fontWeight: .light, alingment: .natural)
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(nameLabel, typeLabel, dimensionLabel)
        accessoryType = .disclosureIndicator
        typeLabel.textColor = .secondaryLabel
        dimensionLabel.textColor = .secondaryLabel
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        typeLabel.text = nil
        dimensionLabel.text = nil
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant:  10),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant:  10),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant:  -10),
            
            typeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant:  10),
            typeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant:  10),
            typeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant:  -10),
            
            dimensionLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant:  10),
            dimensionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant:  10),
            dimensionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant:  -10),
            dimensionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant:  -10)
        ])
    }
    
    public func config(with viewModel: RMLocationTableViewCellViewModel) {
        nameLabel.text = viewModel.name
        typeLabel.text = viewModel.type
        dimensionLabel.text = viewModel.dimension
    }
}
