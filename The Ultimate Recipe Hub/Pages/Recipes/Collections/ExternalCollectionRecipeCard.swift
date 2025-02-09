//
//  RecipeCard.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 9.02.2025.
//

import SwiftUI
import Kingfisher

struct ExternalCollectionRecipeCard: View {
    
    var id: UUID
    var source: String
    var scale: CGFloat = 1
    var size: CGFloat = 170

    @State var showWebView: Bool = false
    @StateObject private var metadataFetcher = MetadataFetcher()
    @StateObject private var sourceManager = ExternalSourceManager.shared

    var body: some View {
        VStack {
            // Metadata Image
            if let metadata = metadataFetcher.metadata {
                if let imageUrl = URL(string: metadata.imageUrl) {
                    KFImage(imageUrl)
                        .placeholder {
                            ProgressView()
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: size, height: size)
                        .clipped()
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.7), radius: 2)
                        .onTapGesture(perform: {
                            showWebView = true
                        })
                } else {
                    Color.gray.opacity(0.5)
                        .redacted(reason: .placeholder)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            else {
                Color.gray.opacity(0.5)
                    .redacted(reason: .placeholder)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if let metadata = metadataFetcher.metadata {
                Text(metadata.title)
                    .padding(.top, 1)
                    .font(.system(size: 13 * (1 - scale + 1)))
                    .multilineTextAlignment(.leading)
                    .frame(width: 160, height: 50, alignment: .topLeading) // Limit size and align
                    .lineLimit(2) // Limit text to 2 lines
                    .truncationMode(.tail) // Add "..." if text overflows
            }
        }
        .frame(width: 170, height: 200) // Size of the RecipeCard
        .scaleEffect(scale)
        .onAppear {
            metadataFetcher.fetchMetadata(from: source)
        }
        .fullScreenCover(isPresented: $showWebView, onDismiss: { showWebView = false }) {
            if let url = URL(string: source) {
                SafariView(url: url)
            } else {
                Text("Invalid URL")
            }
        }
    }
    
    func openURL(_ urlString: String) {
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            print("Invalid URL or unable to open")
        }
    }
}
