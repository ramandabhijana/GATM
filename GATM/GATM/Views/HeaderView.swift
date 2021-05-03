//
//  HeaderView.swift
//  GATM
//
//  Created by Abhijana Agung Ramanda on 19/07/20.
//  Copyright © 2020 Abhijana Agung Ramanda. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView
{
    static let reuseIdentifier = "header-reuse-identifier"

    let label = UILabel()

    override init(frame: CGRect) {
      super.init(frame: frame)
      configure()
    }

    required init?(coder: NSCoder) {
      fatalError()
    }
    
    func configure() {
      backgroundColor = .systemBackground
      addSubview(label)
      label.translatesAutoresizingMaskIntoConstraints = false
      label.adjustsFontForContentSizeCategory = true
      let inset = CGFloat(10)
      NSLayoutConstraint.activate([
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
        label.topAnchor.constraint(equalTo: topAnchor, constant: inset),
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
      ])
      label.font = UIFont.preferredFont(forTextStyle: .headline)
    }
    
}
