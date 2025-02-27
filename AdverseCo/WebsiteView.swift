//
//  WebsiteView.swift
//  AdverseCo
//
//  Created by Avanish Singh on 27.02.25.
//


import SwiftUI
import WebKit

struct WebsiteView: View {
    var body: some View {
        WebView(url: URL(string: "https://www.adverseco.com")!)
            .edgesIgnoringSafeArea(.all)
//            .navigationTitle("Company Website")
    }
}

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) { }
}
