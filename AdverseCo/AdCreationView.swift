//
//  AdCreationView.swift
//  AdverseCo
//
//  Created by Avanish Singh on 27.02.25.
//

import SwiftUI
import PhotosUI

// MARK: - Social Media Platforms for Ad Preview
enum SocialMediaPlatform: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    case instagram = "Instagram"
    case twitter = "Twitter"
    case facebook = "Facebook"
}

// MARK: - AdCreationView (Root for Ad Generation)
struct AdCreationView: View {
    @StateObject var adStore = AdStore()
    
    var body: some View {
        NavigationView {
            LandingView()
        }
        .environmentObject(adStore)
    }
}

// MARK: - LandingView (URL Input)
struct LandingView: View {
    @State private var productUrl: String = ""
    @State private var isLoading: Bool = false
    @State private var navigateToAd: Bool = false
    @EnvironmentObject var adStore: AdStore
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Enter Product URL")
                .font(.headline)
            
            TextField("https://example.com/product", text: $productUrl)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button(action: { generateProductDataFromUrl() }) {
                Text("Generate Ad from URL")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(productUrl.isEmpty ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            .disabled(productUrl.isEmpty)
            
            NavigationLink("Manual Input", destination: ManualInputView())
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.horizontal)
            
            NavigationLink(destination: AdvertisementView(), isActive: $navigateToAd) {
                EmptyView()
            }
            
            if isLoading {
                ProgressView("Generating Ad...")
                    .padding()
            }
            
            Spacer()
        }
        .navigationTitle("Ad Generator")
    }
    
    func generateProductDataFromUrl() {
        guard !productUrl.isEmpty else { return }
        isLoading = true
        
        guard let url = URL(string: "https://adverseco-1575cc875608.herokuapp.com/createAd") else {
            print("Invalid URL")
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body: [String: Any] = [
            "url": productUrl,
            "gender": "global",
            "ageGroup": "9-18"
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async { isLoading = false }
            
            if let error = error {
                print("Error:", error.localizedDescription)
                return
            }
            
            guard let data = data,
                  let responseJSON = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let adCopy = responseJSON["adCopy"] as? String else {
                print("Failed to parse response")
                return
            }
            
            let imageUrlString = responseJSON["imageUrl"] as? String
            let validImageUrl: String = {
                if let imageUrl = imageUrlString,
                   !imageUrl.isEmpty,
                   imageUrl.lowercased().hasPrefix("http") {
                    return imageUrl
                } else {
                    return "https://dummyimage.com/300x300/cccccc/ffffff.png"
                }
            }()
            print("Scraped image URL:", validImageUrl)
            
            let productData = ProductData(
                brandName: responseJSON["brandName"] as? String ?? "Unknown Brand",
                productName: responseJSON["productName"] as? String ?? "Unknown Product",
                productDescription: responseJSON["productDescription"] as? String ?? "",
                targetAudience: responseJSON["targetAudience"] as? String ?? "",
                uniqueSellingPoints: responseJSON["uniqueSellingPoints"] as? String ?? "",
                imageUrl: validImageUrl,
                adCopy: adCopy
            )
            
            DispatchQueue.main.async {
                adStore.setProductData(productData)
                navigateToAd = true
            }
        }.resume()
    }
}

// MARK: - ManualInputView (for manual ad creation)
struct ManualInputView: View {
    @State private var brandName: String = ""
    @State private var productName: String = ""
    @State private var productDescription: String = ""
    @State private var targetAudience: String = ""
    @State private var uniqueSellingPoints: String = ""
    @State private var isLoading: Bool = false
    @State private var navigateToAd: Bool = false
    @EnvironmentObject var adStore: AdStore
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Group {
                    Text("Brand Name")
                    TextField("Enter brand name", text: $brandName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("Product Name")
                    TextField("Enter product name", text: $productName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("Product Description")
                    TextField("Enter product description", text: $productDescription)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("Target Audience")
                    TextField("Enter target audience", text: $targetAudience)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("Unique Selling Points")
                    TextField("Enter unique selling points", text: $uniqueSellingPoints)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)
                
                Button(action: { generateAdFromManualInput() }) {
                    Text("Generate Ad")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background((brandName.isEmpty || productName.isEmpty) ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                .disabled(brandName.isEmpty || productName.isEmpty)
                
                if isLoading {
                    ProgressView("Generating Ad...")
                        .padding()
                }
                
                NavigationLink(destination: AdvertisementView(), isActive: $navigateToAd) {
                    EmptyView()
                }
                
                Spacer()
            }
            .navigationTitle("Manual Product Info")
        }
    }
    
    func generateAdFromManualInput() {
        isLoading = true
        guard let url = URL(string: "https://adverseco-1575cc875608.herokuapp.com/generateAdPrompt") else {
            print("Invalid URL")
            isLoading = false
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body: [String: Any] = [
            "brandName": brandName,
            "productName": productName,
            "productDescription": productDescription,
            "targetAudience": targetAudience,
            "uniqueSellingPoints": uniqueSellingPoints
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async { isLoading = false }
            if let error = error {
                print("Error:", error.localizedDescription)
                return
            }
            guard let data = data,
                  let responseJSON = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let adCopy = responseJSON["adCopy"] as? String else {
                print("Failed to parse response")
                return
            }
            let productData = ProductData(
                brandName: brandName,
                productName: productName,
                productDescription: productDescription,
                targetAudience: targetAudience,
                uniqueSellingPoints: uniqueSellingPoints,
                imageUrl: responseJSON["imageUrl"] as? String ?? "https://dummyimage.com/300x300/cccccc/ffffff.png",
                adCopy: adCopy
            )
            DispatchQueue.main.async {
                adStore.setProductData(productData)
                navigateToAd = true
            }
        }.resume()
    }
}

// MARK: - AdvertisementView (Ad Preview with Image Upload)
struct AdvertisementView: View {
    @EnvironmentObject var adStore: AdStore
    @State private var selectedPlatform: SocialMediaPlatform = .instagram
    @State private var showingImagePicker = false
    @State private var uploadedImage: UIImage? = nil
    
    var body: some View {
        if let productData = adStore.productData {
            ScrollView {
                VStack(spacing: 20) {
                    Picker("Select Platform", selection: $selectedPlatform) {
                        ForEach(SocialMediaPlatform.allCases) { platform in
                            Text(platform.rawValue).tag(platform)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    AdPreviewView(productData: productData,
                                  platform: selectedPlatform,
                                  selectedImage: uploadedImage)
                        .padding()
                    
                    // Show only ad copy as caption.
                    Text(productData.adCopy)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                    HStack {
                        Button(action: { showingImagePicker = true }) {
                            Text("Upload Image")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        Button(action: { shareAd() }) {
                            Text("Share Ad")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                }
                .navigationTitle("Your Advertisement")
            }
            .sheet(isPresented: $showingImagePicker) {
                PhotoPicker(selectedImage: $uploadedImage)
            }
        } else {
            Text("No advertisement data available.")
        }
    }
    
    func shareAd() {
        // Implement sharing functionality as needed.
    }
}

// MARK: - AdPreviewView (Image Preview)
struct AdPreviewView: View {
    let productData: ProductData
    let platform: SocialMediaPlatform
    let selectedImage: UIImage?
    
    var body: some View {
        let previewHeight: CGFloat = {
            switch platform {
            case .instagram: return 300
            case .twitter: return 200
            case .facebook: return 400
            }
        }()
        
        let imageView: AnyView = {
            if let uiImage = selectedImage {
                return AnyView(
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .clipped()
                )
            } else if let imageUrl = productData.imageUrl, let url = URL(string: imageUrl) {
                return AnyView(
                    AsyncImage(url: url) { image in
                        image.resizable()
                             .aspectRatio(contentMode: .fill)
                             .frame(maxWidth: .infinity)
                             .clipped()
                    } placeholder: {
                        Color.gray.frame(height: previewHeight)
                    }
                )
            } else {
                return AnyView(Color.gray.frame(height: previewHeight))
            }
        }()
        
        return VStack(spacing: 0) {
            imageView
                .frame(height: previewHeight)
        }
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

// MARK: - PhotoPicker (Using PHPickerViewController)
struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider,
                  provider.canLoadObject(ofClass: UIImage.self) else { return }
            provider.loadObject(ofClass: UIImage.self) { object, error in
                DispatchQueue.main.async {
                    if let uiImage = object as? UIImage {
                        self.parent.selectedImage = uiImage
                    }
                }
            }
        }
    }
}

// MARK: - Preview Provider for AdCreationView
struct AdCreationView_Previews: PreviewProvider {
    static var previews: some View {
        AdCreationView()
            .environmentObject(AdStore())
    }
}
