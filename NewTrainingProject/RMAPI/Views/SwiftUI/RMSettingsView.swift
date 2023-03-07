//
//  RMSettingsView.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 31.01.2023.
//

import SwiftUI

struct RMSettingsView: View {
    let viewModel: RMSettingsViewViewModel
    init(viewModel: RMSettingsViewViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
            List(viewModel.cellViewModel) { viewModel in
                HStack{
                    if let image = viewModel.image {
                        Image(uiImage: image)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height:  20)
                            .padding(8)
                            .background(Color(viewModel.iconContainerColor))
                            .cornerRadius(6)
                    }
                    Text(viewModel.title)
                        .padding(.leading, 10)
                    Spacer()
                }
                .padding(.bottom, 5)
                .onTapGesture {
                    viewModel.onTapHandler(viewModel.type)
                }
            }
    }
}

struct RMSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        RMSettingsView(viewModel: .init(cellViewModel: RMSettingsOption.allCases.compactMap({
            return RMSettingsCellViewModel(type: $0) {option in
                
            }
        })))
    }
}
