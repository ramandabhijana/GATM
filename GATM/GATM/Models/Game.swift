//
//  Game.swift
//  GATM
//
//  Created by Abhijana Agung Ramanda on 09/07/20.
//  Copyright © 2020 Abhijana Agung Ramanda. All rights reserved.
//

import UIKit

final class Game: Codable {
    var id: Int
    var name: String
    var releaseDate: Date?
    var rating: Double
    var platforms: [Platform]?
    var genres = [Genre]()
    var imageURLString: String?
    var playtime: Int?
    var description: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case releaseDate = "released"
        case rating
        case genres
        case imageURLString = "background_image"
        case platforms
        case playtime
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let dateString = try? container.decode(String.self, forKey: .releaseDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let dateString = dateString {
            releaseDate = formatter.date(from: dateString)
        }
        
        platforms = try? container.decode([Platform].self, forKey: .platforms)
        imageURLString = try? container.decode(String.self, forKey: .imageURLString)
        genres = try container.decode([Genre].self, forKey: .genres)
        rating = try container.decode(Double.self, forKey: .rating)
        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(Int.self, forKey: .id)
        playtime = try? container.decode(Int.self, forKey: .playtime)
    }
    
    init(byConverting gameModel: GameModel) {
        self.id = Int(gameModel.id!)
        self.name = gameModel.name!
        self.releaseDate = gameModel.releaseDate
        self.rating = gameModel.rating!
        self.playtime = Int(gameModel.playtime!)
        self.description = gameModel.about
        self.imageURLString = nil
        
        self.genres = generateGenres(from: gameModel.genres)
        self.platforms = generatePlatforms(from: gameModel.platforms)
    }
    
    private func generateGenres(from data: Data?) -> [Genre] {
        let genresAsStringArray = try! JSONDecoder().decode([String].self, from: data!)
        let genres = genresAsStringArray.map { Genre(name: $0) }
        return genres
    }
    
    private func generatePlatforms(from data: Data?) -> [Platform] {
        let platformsNameAsStringArray = try! JSONDecoder().decode([String].self, from: data!)
        let platforms = platformsNameAsStringArray.map {
            Platform( platform: Platform.Platform.init(name: $0) )
        }
        return platforms
    }
    
}

// MARK: - Conforms to the Hashable
extension Game: Hashable {
    static func == (lhs: Game, rhs: Game) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Additional Game Data
struct Platform: Codable {
    let platform: Platform
    struct Platform: Codable {
        let name: String
    }
}

struct Genre: Codable {
    let name: String
}

struct Description: Codable {
    let description: String
    enum CodingKeys: String, CodingKey {
        case description = "description_raw"
    }
}



