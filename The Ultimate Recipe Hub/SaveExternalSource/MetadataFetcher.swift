//
//  RecipeSaver.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 13.12.2024.
//

import SwiftUI
import Combine
import SwiftSoup

struct WebpageMetadata {
    var title: String
    var description: String
    var imageUrl: String
}

class MetadataFetcher: ObservableObject {
    
    // Singleton instance
    static let shared = MetadataFetcher()
    
    @Published var metadata: WebpageMetadata?
    
    func isValidUrl(_ url: String, completion: @escaping (Bool) -> Void) {
        guard let validUrl = URL(string: url), UIApplication.shared.canOpenURL(validUrl) else {
            completion(false)
            return
        }

        URLSession.shared.dataTask(with: validUrl) { data, response, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }

            if let html = String(data: data, encoding: .utf8) {
                do {
                    let document = try SwiftSoup.parse(html)
                    let title = try document.select("meta[property=og:title]").attr("content")
                    let description = try document.select("meta[property=og:description]").attr("content")
                    let imageUrl = try document.select("meta[property=og:image]").attr("content")
                    
                    let isValid = !(title.isEmpty && description.isEmpty && imageUrl.isEmpty)
                    DispatchQueue.main.async {
                        completion(isValid)
                    }
                } catch {
                    print("Error parsing HTML: \(error)")
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }.resume()
    }
    
    func fetchMetadata(from url: String, retryCount: Int = 3) {
        guard let validUrl = URL(string: url) else {
            print("Invalid URL: \(url)")
            return
        }
        
        URLSession.shared.dataTask(with: validUrl) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else {
                if retryCount > 0 {
                    self?.fetchMetadata(from: url, retryCount: retryCount - 1) // Retry
                } else {
                    print("Failed to fetch metadata after retries for URL: \(url)")
                }
                return
            }
            
            if let html = String(data: data, encoding: .utf8) {
                self.parseHTML(html: html)
            }
        }.resume()
    }
    
    private func parseHTML(html: String) {
        do {
            let document = try SwiftSoup.parse(html)
            let title = try document.select("meta[property=og:title]").attr("content")
            let description = try document.select("meta[property=og:description]").attr("content")
            let imageUrl = try document.select("meta[property=og:image]").attr("content")
            
            DispatchQueue.main.async {
                self.metadata = WebpageMetadata(
                    title: title.isEmpty ? "No Title Found" : title,
                    description: description.isEmpty ? "No Description Found" : description,
                    imageUrl: imageUrl.isEmpty ? "No Image URL Found" : imageUrl
                )
            }
        } catch {
            print("Error parsing HTML: \(error)")
        }
    }
}
