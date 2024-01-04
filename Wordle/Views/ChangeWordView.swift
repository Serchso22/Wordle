//
//  ChangeWordView.swift
//  Wordle
//
//  Created by Jorge Sergio Islas Ramos on 02/01/24.
//

import SwiftUI

struct ChangeWordView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Text("Please enter the new answer word.")
                .font(.title2)
            Text("Remember the word must be 5 letters long.")
                .font(.caption)
                .italic()
                .padding(.bottom)
            TextField("Answer word", text: $viewModel.result)
                .padding()
                .background(.gray)
                .cornerRadius(15.0)
            Button("Submit") {
                viewModel.result = viewModel.result.self
                viewModel.isShowingChangeWord = false
            }
            .foregroundColor(.white)
            .padding()
            .background(.blue)
            .cornerRadius(12)
        }
        .padding()
    }
}

#Preview {
    ChangeWordView()
}
