//
//  AdStore.swift
//  AdverseCo
//
//  Created by Avanish Singh on 27.02.25.
//

import Foundation
import SwiftUI

// MARK: - Data Model
struct ProductData: Codable, Identifiable {
    // Using productName as an identifier (change as needed)
    var id: String { productName }
    let brandName: String
    let productName: String
    let productDescription: String
    let targetAudience: String
    let uniqueSellingPoints: String
    let imageUrl: String?   // URL from backend (if any)
    let adCopy: String
}

// MARK: - AdStore (Persistent Storage)
class AdStore: ObservableObject {
    @Published var productData: ProductData? {
        didSet {
            saveData()
        }
    }
    
    private let storageKey = "adData"
    
    init() {
        loadData()
    }
    
    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: storageKey) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(ProductData.self, from: data) {
                self.productData = decoded
            }
        }
    }
    
    private func saveData() {
        guard let productData = productData else { return }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(productData) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    func setProductData(_ data: ProductData) {
        self.productData = data
    }
}
