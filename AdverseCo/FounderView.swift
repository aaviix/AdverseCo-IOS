//
//  FounderView.swift
//  AdverseCo
//
//  Created by Avanish Singh on 27.02.25.
//

import SwiftUI

struct FounderView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Founder image from Assets.xcassets (named "founder")
                Image("founder")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.bottom, 10)
                
                Text("About the Founder")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Avanish Singh is the visionary founder of AdverseCo. With a passion for innovation and advertising, Avanish has dedicated his career to revolutionizing digital marketing. His work focuses on creating hyper-targeted, AI-driven advertising solutions that deliver measurable results.")
                
                Text("Under his leadership, AdverseCo is transforming how companies connect with their audiences. Avanish combines a deep understanding of technology with creative business strategies to drive growth and success.")
                
                Text("Learn more about his journey, insights, and vision for the future of advertising.")
                
                Divider()
                    .padding(.vertical)
                
                Text("Connect with Avanish")
                    .font(.headline)
                
                // Social media links using SwiftUI's Link view.
                VStack(alignment: .leading, spacing: 10) {
                    Link("LinkedIn", destination: URL(string: "https://www.linkedin.com/in/aaviix")!)
                        .foregroundColor(.blue)
                    Link("GitHub", destination: URL(string: "https://github.com/aaviix")!)
                        .foregroundColor(.blue)
                    Link("Personal Website", destination: URL(string: "https://aaviix-2025.vercel.app")!)
                        .foregroundColor(.blue)
                }
                .font(.body)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Founder")
    }
}

struct FounderView_Previews: PreviewProvider {
    static var previews: some View {
        FounderView()
    }
}
