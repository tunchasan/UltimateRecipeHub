//
//  ImageCache.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 28.12.2024.
//

import UIKit

final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()

    private init() {}

    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }

    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    func clearCache() {
        cache.removeAllObjects()
    }
}
