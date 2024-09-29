//
//  MetalPriceViewModel.swift
//  BullionTrack
//
//  Created by DEEP BHUPATKAR on 29/09/24.
//

import Foundation

class MetalPriceViewModel: ObservableObject {
    @Published var metalSymbol: String = "XAU"//",XAG,XPD"  // Default is gold (XAU)
    @Published var metalPrice: Double?
    @Published var errorMessage: String?
    @Published var baseCurrency : String = "INR"

    private let apiKey = ""  // Replace with your API key
    private let baseUrl = "https://metals-api.com/api/latest"
    
    

    // Function to fetch metal price
    func fetchMetalPrice() {
        let apiEndpoint = "\(baseUrl)?access_key=\(apiKey)&symbols=\(metalSymbol)&base=\(baseCurrency)"
        
        guard let url = URL(string: apiEndpoint) else {
            self.errorMessage = "Invalid URL"
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data received"
                    return
                }

                // Print the raw JSON response to debug the issue
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON Response: \(jsonString)")
                }

                do {
                    let jsonResponse = try JSONDecoder().decode(MetalPriceResponse.self, from: data)
                    
                    // Handle success or error in response
                    if let success = jsonResponse.success, success {
                        if let rate = jsonResponse.rates?[self.metalSymbol] {
                            self.metalPrice = rate
                        } else {
                            self.errorMessage = "Metal not found"
                        }
                    } else if let apiError = jsonResponse.error {
                        self.errorMessage = "Error \(apiError.code): \(apiError.info)"
                    } else {
                        self.errorMessage = "Unknown error occurred"
                    }
                } catch {
                    self.errorMessage = "Error parsing data: \(error)"
                }
            }
        }.resume()
    }


}


struct MetalPriceResponse: Codable {
    let success: Bool?
    let rates: [String: Double]?
    let error: APIError?
}

struct APIError: Codable {
    let code: Int
    let type: String
    let info: String
}
