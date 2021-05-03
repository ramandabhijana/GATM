//
//  HomeData.swift
//  GATM
//
//  Created by Abhijana Agung Ramanda on 19/07/20.
//  Copyright © 2020 Abhijana Agung Ramanda. All rights reserved.
//

import UIKit

private var featured1UrlComponents: URLComponents? {
    return NetworkingService.generateURLComponents(withQueryItems: [
        URLQueryItem(name: "dates", value: "2020-01-01,2020-12-31"),
        URLQueryItem(name: "ordering", value: "-added")
    ])
}

private var featured2UrlComponents: URLComponents? {
    return NetworkingService.generateURLComponents(withQueryItems: [
        URLQueryItem(name: "dates", value: "2019-01-01,2019-12-31"),
        URLQueryItem(name: "ordering", value: "-added")
    ])
}

private var featured3UrlComponents: URLComponents? {
    return NetworkingService.generateURLComponents(withQueryItems: [
        URLQueryItem(name: "publishers", value: "electronic-arts"),
        URLQueryItem(name: "ordering", value: "-added")
    ])
}

private var ps4UrlComponents: URLComponents? {
    return NetworkingService.generateURLComponents(withQueryItems: [
        URLQueryItem(name: "platforms", value: "18")
    ])
}

private var pcUrlComponents: URLComponents? {
    return NetworkingService.generateURLComponents(withQueryItems: [
        URLQueryItem(name: "platforms", value: "4")
    ])
}

private var switchUrlComponents: URLComponents? {
    return NetworkingService.generateURLComponents(withQueryItems: [
        URLQueryItem(name: "platforms", value: "7")
    ])
}

private var xboxOneUrlComponents: URLComponents? {
    return NetworkingService.generateURLComponents(withQueryItems: [
        URLQueryItem(name: "platforms", value: "1")
    ])
}

private var actionUrlComponents: URLComponents? {
    return NetworkingService.generateURLComponents(withQueryItems: [
        URLQueryItem(name: "genres", value: "action")
    ])
}
private var adventureUrlComponents: URLComponents? {
    return NetworkingService.generateURLComponents(withQueryItems: [
        URLQueryItem(name: "genres", value: "adventure")
    ])
}
private var puzzleUrlComponents: URLComponents? {
    return NetworkingService.generateURLComponents(withQueryItems: [
        URLQueryItem(name: "genres", value: "puzzle")
    ])
}
private var racingUrlComponents: URLComponents? {
    return NetworkingService.generateURLComponents(withQueryItems: [
        URLQueryItem(name: "genres", value: "racing")
    ])
}
private var rpgUrlComponents: URLComponents? {
    return NetworkingService.generateURLComponents(withQueryItems: [
        URLQueryItem(name: "genres", value: "role-playing-games-rpg")
    ])
}
private var shooterUrlComponents: URLComponents? {
    return NetworkingService.generateURLComponents(withQueryItems: [
        URLQueryItem(name: "genres", value: "shooter")
    ])
}
private var sportsUrlComponents: URLComponents? {
    return NetworkingService.generateURLComponents(withQueryItems: [
        URLQueryItem(name: "genres", value: "sports")
    ])
}
private var strategyUrlComponents: URLComponents? {
    return NetworkingService.generateURLComponents(withQueryItems: [
        URLQueryItem(name: "genres", value: "strategy")
    ])
}

let featuredItems = [
    CollectionItem(itemImage: UIImage(named: "Featured1")!, itemTitle: "Release This Year", urlComponents: featured1UrlComponents!),
    CollectionItem(itemImage: UIImage(named: "Featured2")!, itemTitle: "Best Of 2019", urlComponents: featured2UrlComponents!),
    CollectionItem(itemImage: UIImage(named: "Featured3")!, itemTitle: "Published By EA", urlComponents: featured3UrlComponents!)
]

let platformItems = [
    CollectionItem(itemImage: UIImage(named: "playstation")!, itemTitle: "Playstation 4", urlComponents: ps4UrlComponents!),
    CollectionItem(itemImage: UIImage(named: "switch")!, itemTitle: "Nintendo Switch", urlComponents: switchUrlComponents!),
    CollectionItem(itemImage: UIImage(named: "xbox")!, itemTitle: "Xbox One", urlComponents: xboxOneUrlComponents!),
    CollectionItem(itemImage: UIImage(named: "windows")!, itemTitle: "Windows PC", urlComponents: pcUrlComponents!)
]

let genreItems = [
    CollectionItem(itemImage: UIImage(named: "Action")!, itemTitle: "Action", urlComponents: actionUrlComponents!),
    CollectionItem(itemImage: UIImage(named: "Adventure")!, itemTitle: "Adventure", urlComponents: adventureUrlComponents!),
    CollectionItem(itemImage: UIImage(named: "Puzzle")!, itemTitle: "Puzzle", urlComponents: puzzleUrlComponents!),
    CollectionItem(itemImage: UIImage(named: "Racing")!, itemTitle: "Racing", urlComponents: racingUrlComponents!),
    CollectionItem(itemImage: UIImage(named: "RPG")!, itemTitle: "RPG", urlComponents: rpgUrlComponents!),
    CollectionItem(itemImage: UIImage(named: "Shooter")!, itemTitle: "Shooter", urlComponents: shooterUrlComponents!),
    CollectionItem(itemImage: UIImage(named: "Sports")!, itemTitle: "Sports", urlComponents: sportsUrlComponents!),
    CollectionItem(itemImage: UIImage(named: "Strategy")!, itemTitle: "Strategy", urlComponents: strategyUrlComponents!)
]
