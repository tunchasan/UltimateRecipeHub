//
//  SavedRecipe.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 23.12.2024.
//

import Foundation

struct ExternalSource: Identifiable {
    let id: UUID
    let url: String
    
    init(id: UUID = UUID(), url: String) {
        self.id = id
        self.url = url
    }
}
