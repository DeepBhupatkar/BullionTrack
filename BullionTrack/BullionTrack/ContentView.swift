//
//  ContentView.swift
//  BullionTrack
//
//  Created by DEEP BHUPATKAR on 29/09/24.
//

import SwiftUI

struct ContentView: View {
    // ViewModel to manage API logic
    @StateObject private var viewModel = MetalPriceViewModel()

    @FocusState private var isInputActive: Bool // For dismissing the keyboard
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Metal Price Fetcher")
                .font(.largeTitle)
                .padding()

            // Metal symbol input field
            TextField("Enter Metal Symbol (e.g., XAU for Gold)", text: $viewModel.metalSymbol)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .focused($isInputActive)

            // Base currency input field
            TextField("Enter Base Currency (e.g., USD, INR)", text: $viewModel.baseCurrency)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .focused($isInputActive)

            // Button to fetch prices
            Button(action: {
                isInputActive = false // Dismiss the keyboard
                viewModel.fetchMetalPrice()
            }) {
                Text("Fetch Metal Price")
                    .fontWeight(.bold)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            // Loading indicator
            if viewModel.metalPrice == nil && viewModel.errorMessage == nil {
                ProgressView("Fetching Price...")
                    .padding()
            }

            // Show the metal price or error
            if let price = viewModel.metalPrice {
                Text("Price: \(price, specifier: "%.2f") \(viewModel.baseCurrency)")
                    .font(.title2)
                    .padding()
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .padding()
            }

            Spacer()
        }
        .padding()
        .onTapGesture {
            isInputActive = false // Dismiss the keyboard on tap outside
        }
    }
}
