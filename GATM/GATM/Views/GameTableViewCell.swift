//
//  GameTableViewCell.swift
//  GATM
//
//  Created by Abhijana Agung Ramanda on 10/07/20.
//  Copyright © 2020 Abhijana Agung Ramanda. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailView: NetworkingImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    static let ReuseIdentifier = String(describing: GameTableViewCell.self)
    static let NibName = String(describing: GameTableViewCell.self)
    
    var game: Game? {
        didSet {
            if let game = game {
                setupImageView()
                titleLabel.text = game.name
                setupSubtitleLabel(game)
            }
        }
    }
    
    var gameModel: GameModel? {
        didSet {
            if let game = gameModel {
                thumbnailView.image = UIImage(data: game.image!)
                titleLabel.text = game.name
                setupSubtitleLabel(game)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setupImageView() {
        if let imageURLString = game?.imageURLString {
            thumbnailView.loadUsingUrlString(imageURLString, indicator: spinner)
        } else {
            thumbnailView.image = UIImage(named: "ImgNotFound")
        }
    }
    
    func setupSubtitleLabel<T>(_ game: T) {
        var gameReleaseDate: Date?
        var gameRating: Double
        
        switch game {
        case is GameModel:
            let game = game as! GameModel
            gameReleaseDate = game.releaseDate
            gameRating = game.rating ?? 0
        case is Game:
            let game = game as! Game
            gameReleaseDate = game.releaseDate
            gameRating = game.rating
        default: fatalError()
        }
        
        var releaseDateString: String?
        if let gameReleaseDate = gameReleaseDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Locale(identifier: "en_US")
            releaseDateString = dateFormatter.string(from: gameReleaseDate)
        }
        subtitleLabel.text = "\(gameRating)/5 • " + (releaseDateString ?? "Unrevealed")
    }

}
