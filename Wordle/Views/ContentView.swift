//
//  ContentView.swift
//  Wordle
//
//  Created by Jorge Sergio Islas Ramos on 02/01/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 40) {
                    GameView(viewModel: viewModel)
                    KeyboardView(viewModel: viewModel)
                }
                if viewModel.bannerType != nil {
                    BannerView(bannerType: viewModel.bannerType!)
                }
            }
            .navigationTitle("Wordle")
            .toolbar{
                Button {
                    viewModel.isShowingChangeWord = true
                } label: {
                    Label("Change answer word", systemImage: "pencil.circle")
                }
                .sheet(isPresented: $viewModel.isShowingChangeWord) {
                    ChangeWordView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
