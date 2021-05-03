//
//  NetworkingService.swift
//  GATM
//
//  Created by Abhijana Agung Ramanda on 09/07/20.
//  Copyright © 2020 Abhijana Agung Ramanda. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
}

class NetworkingService {
    static let apiEndpoint = "https://api.rawg.io/api/games"
    var task: URLSessionTask?
    
    static func generateURLComponents(withQueryItems queryItems: [URLQueryItem]) -> URLComponents? {
        var components = URLComponents(string: apiEndpoint)
        components?.queryItems = queryItems
        return components
    }
    
    func getGames(urlComponents: URLComponents?,
                  page: Int,
                  onCompletion: @escaping (GamesResult) -> Void) {
        
        func fireErrorCompletion(_ error: Error?) {
            onCompletion(GamesResult(games: nil,
                                     error: error,
                                     currentPage: 0,
                                     nextPageUrlString: nil))
        }
        
        guard let url = urlComponents?.url else {
            fireErrorCompletion(NetworkError.invalidURL)
            return
        }
        task?.cancel()
        
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                  guard (error as NSError).code != NSURLErrorCancelled else {
                    return
                  }
                  fireErrorCompletion(error)
                  return
                }
                
                guard let data = data else {
                  fireErrorCompletion(error)
                  return
                }
                
                do {
                    let result = try JSONDecoder().decode(ServiceResponse.self, from: data)
                    let games = result.results
                    onCompletion(GamesResult(games: games,
                                             error: nil,
                                             currentPage: page,
                                             nextPageUrlString: result.next))
                } catch {
                    fireErrorCompletion(error)
                }
            }
        }
        task?.resume()
    }
    
    func getGameDescription(for gameId: Int,
                            onCompletion: @escaping (DescriptionResult) -> Void) {
        
        func fireErrorCompletion(_ error: Error) {
            onCompletion(DescriptionResult(description: nil,
                                           error: error))
        }
        
        var components = URLComponents(string: NetworkingService.apiEndpoint)
        components?.path = "/api/games/\(gameId)"
        
        guard let url = components?.url else {
            fireErrorCompletion(NetworkError.invalidURL)
            return
        }
        task?.cancel()
        
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                  guard (error as NSError).code != NSURLErrorCancelled else { return }
                  fireErrorCompletion(error)
                  return
                }
                guard let data = data else {
                    fireErrorCompletion(error!)
                    return
                }
                do {
                    let result = try JSONDecoder().decode(Description.self, from: data)
                    onCompletion(DescriptionResult(description: result, error: nil))
                } catch {
                    fireErrorCompletion(error)
                }
            }
        }
        task?.resume()
    }
}
