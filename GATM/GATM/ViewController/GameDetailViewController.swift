//
//  GameViewController.swift
//  GATM
//
//  Created by Abhijana Agung Ramanda on 11/07/20.
//  Copyright © 2020 Abhijana Agung Ramanda. All rights reserved.
//

import UIKit

class GameDetailViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var gameImageView: NetworkingImageView!
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageLoadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var favoritesButtonItem: UIBarButtonItem!
    
    
    @IBAction func openZooming(_ sender: AnyObject) {
        if gameImageView.image != nil {
            self.performSegue(withIdentifier: "zooming", sender: nil)
        }
    }
    @IBAction func gameFavorited(_ sender: UIBarButtonItem) {
        if isFavorite {
            let alert = UIAlertController(title: "Warning",
                                          message: "Remove this game from your favorites?",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { action in
                self.removeGameFromFavorites()
                self.isFavorite = false
            })
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            addGameToFavorites()
            isFavorite = true
        }
    }
    
    @IBAction func openPlatformName(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "goToPlatform", sender: nil)
    }
    
    
    // MARK: - Properties
    var thumbnailImage: UIImage?
    private lazy var gameProvider: GameProvider = {
        return GameProvider()
    }()
    var game: Game! {
        didSet {
            checkIsGameFavorited()
        }
    }
    private var isFavorite = false {
        didSet {
            favoritesButtonItem.image = UIImage(
                systemName: isFavorite ? "heart.fill" : "heart")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImageViewAndDescription()
        
        gameTitleLabel.text = game.name
        hoursLabel.text = String(game.playtime ?? 0)
        
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.isUserInteractionEnabled = false
        descriptionTextView.isHidden = false
        resize(textView: descriptionTextView)
        
        let genres = game.genres.map { $0.name }
        genresLabel.text = genres.joined(separator: ", ")
        ratingsLabel.text = String(game.rating)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        if let releaseDate =  game.releaseDate {
            yearLabel.text = dateFormatter.string(from: releaseDate)
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd")
            dateLabel.text = dateFormatter.string(from: releaseDate)
        } else {
            yearLabel.text = "NULL"
            dateLabel.text = "Unstated"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkIsGameFavorited()
    }
    
    private func setupImageViewAndDescription() {
        guard thumbnailImage == nil,
            game.description == nil
            else {
                gameImageView.image = thumbnailImage
                descriptionTextView.text = game.description
                self.loadIndicator.stopAnimating()
                return
        }
        let networkingService = NetworkingService()
        DispatchQueue.main.async {
            networkingService.getGameDescription(for: self.game.id) { response in
                self.descriptionTextView.text =
                    response.description?.description ?? "Description not available"
                self.loadIndicator.stopAnimating()
            }
            if let imageURLString = self.game.imageURLString {
                self.gameImageView.loadUsingUrlString(imageURLString, indicator: self.imageLoadIndicator)
            } else {
                self.gameImageView.image = UIImage(named: "ImgNotFound")
            }
        }
    }
    
    // Untuk resize lebar dan tinggi frame textView
    private func resize(textView: UITextView) {
        var newFrame = textView.frame
        let width = newFrame.size.width
        let newSize = textView.sizeThatFits(
            CGSize(width: width,
                   height: CGFloat.greatestFiniteMagnitude))
        newFrame.size = CGSize(width: width, height: newSize.height)
        textView.frame = newFrame
        textViewHeightConstraint.isActive = false
    }
    
    private func checkIsGameFavorited() {
        gameProvider.fetchGame(byId: game.id) { [weak self] result in
            self?.isFavorite = result != nil
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let zoomedPhotoVC = segue.destination as? ZoomedPhotoViewController {
            zoomedPhotoVC.photo = gameImageView.image
        }
        
        if segue.identifier == "goToPlatform" {
            if let vc = segue.destination as? PlatformListViewController {
                let names = game.platforms?.map { $0.platform.name }
                vc.names = names ?? []
            }
        }
    }
    
}

// MARK: - Core Data
extension GameDetailViewController
{
    private func addGameToFavorites() {
        if let image = gameImageView.image,
            let data = image.pngData() as NSData?,
            let description = descriptionTextView.text {
            
            let platformNamesAsString = game.platforms?.map { $0.platform.name }.description
            let platformNamesAsData = (platformNamesAsString?.data(using: String.Encoding.utf16))!
            
            let genreNamesAsString = game.genres.map { $0.name }.description
            let genreNamesAsData = (genreNamesAsString.data(using: String.Encoding.utf16))!
            
            gameProvider.createGame(game.id,
                                    game.name,
                                    game.releaseDate,
                                    game.rating,
                                    platformNamesAsData,
                                    genreNamesAsData,
                                    data as Data,
                                    game.playtime ?? 0,
                                    description)
            {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Yaay 🥳",
                                                  message: "Added to favorites",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK",
                                                  style: .default,
                                                  handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func removeGameFromFavorites() {
        gameProvider.deleteGame(game.id) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Successful",
                                              message: "Removed from favorties",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { (action) in
                    self.navigationController?.popViewController(animated: true)
                })
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
