//
//  AlbumItem.swift
//  GATM
//
//  Created by Abhijana Agung Ramanda on 19/07/20.
//  Copyright © 2020 Abhijana Agung Ramanda. All rights reserved.
//

import UIKit

class CollectionItem: Hashable
{
    private let identifier = UUID()
    let itemTitle: String
    let itemImage: UIImage
    let urlComponents: URLComponents
    
    init(itemImage: UIImage, itemTitle: String, urlComponents: URLComponents) {
        self.itemTitle = itemTitle
        self.itemImage = itemImage
        self.urlComponents = urlComponents
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: CollectionItem, rhs: CollectionItem) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
