//
//  GenreItemCell.swift
//  GATM
//
//  Created by Abhijana Agung Ramanda on 19/07/20.
//  Copyright © 2020 Abhijana Agung Ramanda. All rights reserved.
//

import UIKit

class GenreItemCell: UICollectionViewCell
{
    static let reuseIdentifier = "genre-item-cell-reuse-identifier"
    let titleLabel = UILabel()
    let imageView = UIImageView()
    let contentContainer = UIView()
    
    var title: String? {
        didSet {
            configure()
        }
    }
    
    var image: UIImage? {
        didSet {
            configure()
        }
    }
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      configure()
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        contentView.addSubview(contentContainer)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentContainer.addSubview(imageView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowRadius = 3.0
        titleLabel.layer.shadowOpacity = 1.0
        titleLabel.layer.shadowOffset = CGSize(width: 4, height: 4)
        titleLabel.layer.masksToBounds = false
        contentContainer.addSubview(titleLabel)

        NSLayoutConstraint.activate([
          contentContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
          contentContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
          contentContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
          contentContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

          imageView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
          imageView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
          imageView.topAnchor.constraint(equalTo: contentContainer.topAnchor),
          imageView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor),

          titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
          titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
          titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
          titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
}
