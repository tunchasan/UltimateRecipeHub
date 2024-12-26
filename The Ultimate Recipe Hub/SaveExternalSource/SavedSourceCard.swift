//
//  SavedRecipeCard.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 23.12.2024.
//

import SwiftUI

struct SavedSourceCard: View {
    @Binding var id: UUID
    @Binding var source: String
    @State var showWebView: Bool = false
    @StateObject private var sourceManager = ExternalSourceManager.shared

    var isRecipe: Bool
    var size: CGFloat = 170
    var cornerRadius: CGFloat = 12
    var onRemoveAction: () -> Void
    
    @StateObject private var metadataFetcher = MetadataFetcher()
    
    var body: some View {
        ZStack {
            VStack {
                // Metadata Image
                if let metadata = metadataFetcher.metadata {
                    if let imageUrl = URL(string: metadata.imageUrl) {
                        AsyncImage(url: imageUrl) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: size, height: size)
                                    .clipped()
                            default:
                                Color.gray
                                    .frame(width: size, height: size)
                                    .cornerRadius(cornerRadius)
                            }
                        }
                    }
                }
                
                // Metadata Text
                VStack(spacing: 5) {
                    if let metadata = metadataFetcher.metadata {
                        Text(metadata.title)
                            .font(.system(size: 12).bold())
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                            .truncationMode(.tail)
                            .frame(maxWidth: .infinity, minHeight: 30, alignment: .leading)
                        
                        Text(metadata.description)
                            .font(.system(size: 10))
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                            .truncationMode(.tail)
                            .frame(maxWidth: .infinity, minHeight: 30, alignment: .leading)
                        
                        if let output = extractBaseDomain(from: source) {
                            Text(output)
                                .font(.system(size: 12).bold())
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                                .truncationMode(.tail)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding(.horizontal, 5)
                .padding(.bottom, 10)
            }
        }
        .frame(width: size)
        .background(.white)
        .frame(maxHeight: 265)
        .cornerRadius(cornerRadius)
        .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
        .contextMenu {
            Button {
                showWebView = true
            } label: {
                Label("Open in Browser", systemImage: "safari")
            }
            
            Button {
                shareRecipe(url: source)
            } label: {
                Label("Share", systemImage: "square.and.arrow.up")
            }
            
            Button(role: .destructive) {
                
                if isRecipe {
                    sourceManager.removeRecipe(id: id)
                }
                
                else {
                    sourceManager.removeRestaurant(id: id)
                }
                
                onRemoveAction()
                
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .onAppear {
            metadataFetcher.fetchMetadata(from: source)
        }
        .onChange(of: source) { oldSource, newSource in
            if oldSource != newSource {
                metadataFetcher.fetchMetadata(from: newSource)
            }
        }
        .onTapGesture {
            showWebView = true
        }
        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
        .fullScreenCover(isPresented: $showWebView, onDismiss: { showWebView = false }) {
            if let url = URL(string: source) {
                SafariView(url: url)
            } else {
                Text("Invalid URL")
            }
        }
    }
    
    func shareRecipe(url: String) {
        guard let urlToShare = URL(string: url) else { return }
        let activityController = UIActivityViewController(activityItems: [urlToShare], applicationActivities: nil)
        
        // Present the activity controller using the current window scene
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = scene.windows.first?.rootViewController {
            rootViewController.present(activityController, animated: true)
        }
    }
    
    func extractBaseDomain(from url: String) -> String? {
        guard let components = URLComponents(string: url),
              let host = components.host else { return nil }
        return host
    }
    
    func openURL(_ urlString: String) {
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            print("Invalid URL or unable to open")
        }
    }
}
