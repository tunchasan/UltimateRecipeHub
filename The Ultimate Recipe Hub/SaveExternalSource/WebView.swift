//
//  WebView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 23.12.2024.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let safariVC = SFSafariViewController(url: url)
        // App green for Safari's own buttons (Done, back/forward, share). The bar keeps its standard
        // background, so it stays right in light and dark mode; the page itself can't be themed.
        safariVC.preferredControlTintColor = .systemGreen
        return safariVC
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // No updates required
    }
}
