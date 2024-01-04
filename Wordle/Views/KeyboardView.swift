//
//  KeyboardView.swift
//  Wordle
//
//  Created by Jorge Sergio Islas Ramos on 02/01/24.
//

import SwiftUI

struct KeyboardView: View {
    @ObservedObject var viewModel: ViewModel
    
    let columns: [GridItem] = Array(repeating: GridItem(.flexible(minimum: 20), spacing: 0), count: 10)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(keyboardData, id: \.id) { model in
                Button {
                    viewModel.addNewLetter(letterModel: model)
                } label: {
                    Text(model.name)
                        .font(.body)
                }
                .frame(width: 34, height: 50)
                .foregroundColor(model.foregroundColor)
                .background(model.backgroundColor)
                .cornerRadius(8)
            }
        }
        .padding(.horizontal, 8)
    }
}

#Preview {
    KeyboardView(viewModel: ViewModel())
}
