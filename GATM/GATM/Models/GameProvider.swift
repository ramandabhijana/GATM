//
//  GameProvider.swift
//  GATM
//
//  Created by Abhijana Agung Ramanda on 20/07/20.
//  Copyright © 2020 Abhijana Agung Ramanda. All rights reserved.
//

import CoreData
import Foundation

class GameProvider {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GameGATM")
        container.loadPersistentStores { description, error in
            guard error == nil else { fatalError() }
        }
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil
        return container
    }()
    
    // Untuk berkomunikasi dengan database melalui background thread
    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }
    
    func fetchAllGames( completion: @escaping(_ games: [GameModel]) -> () ) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDGame")
            do {
                let results = try taskContext.fetch(fetchRequest)
                var games = [GameModel]()
                results.forEach {
                    let game = GameModel(id: $0.value(forKeyPath: "id") as? Int32,
                                         name: $0.value(forKeyPath: "name") as? String,
                                         releaseDate: $0.value(forKeyPath: "releaseDate") as? Date,
                                         rating: $0.value(forKeyPath: "rating") as? Double,
                                         platforms: $0.value(forKeyPath: "platforms") as? Data,
                                         genres: $0.value(forKeyPath: "genres") as? Data,
                                         image: $0.value(forKeyPath: "image") as? Data,
                                         playtime: $0.value(forKeyPath: "playtime") as? Int32,
                                         about: $0.value(forKeyPath: "about") as? String)
                    games.append(game)
                }
                completion(games)
            } catch let error as NSError {
                print("Fail to fetch 😭. \(error)")
            }
        }
    }
    
    func fetchGame(byId id: Int, completion: @escaping(_ game: GameModel?) -> () ) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDGame")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            do {
                if let result = try taskContext.fetch(fetchRequest).first {
                    let game = GameModel(id: result.value(forKeyPath: "id") as? Int32,
                                         name: result.value(forKeyPath: "name") as? String,
                                         releaseDate: result.value(forKeyPath: "releaseDate") as? Date,
                                         rating: result.value(forKeyPath: "rating") as? Double,
                                         platforms: result.value(forKeyPath: "platforms") as? Data,
                                         genres: result.value(forKeyPath: "genres") as? Data,
                                         image: result.value(forKeyPath: "image") as? Data,
                                         playtime: result.value(forKeyPath: "playtime") as? Int32,
                                         about: result.value(forKeyPath: "about") as? String)
                    completion(game)
                } else {
                    completion(nil)
                }
            } catch let error as NSError {
                print("Fail to fetch 😭. \(error)")
            }
        }
    }
    
    func fetchGame(byName name: String, completion: @escaping(_ game: [GameModel]) -> () ) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDGame")
            fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", name)
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            do {
                let results = try taskContext.fetch(fetchRequest)
                var games = [GameModel]()
                results.forEach {
                    let game = GameModel(id: $0.value(forKeyPath: "id") as? Int32,
                                         name: $0.value(forKeyPath: "name") as? String,
                                         releaseDate: $0.value(forKeyPath: "releaseDate") as? Date,
                                         rating: $0.value(forKeyPath: "rating") as? Double,
                                         platforms: $0.value(forKeyPath: "platforms") as? Data,
                                         genres: $0.value(forKeyPath: "genres") as? Data,
                                         image: $0.value(forKeyPath: "image") as? Data,
                                         playtime: $0.value(forKeyPath: "playtime") as? Int32,
                                         about: $0.value(forKeyPath: "about") as? String)
                    games.append(game)
                }
                completion(games)
            } catch let error as NSError {
                print("Fail to fetch 😭. \(error)")
            }
        }
    }
    
    func createGame(_ id: Int, _ name: String, _ releaseDate: Date?, _ rating: Double, _ platforms: Data, _ genres: Data, _ image: Data, _ playtime: Int, _ about: String, completion: @escaping() -> () ) {
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            if let entity = NSEntityDescription.entity(forEntityName: "CDGame", in: taskContext) {
                let game = NSManagedObject(entity: entity, insertInto: taskContext)
                game.setValue(id, forKey: "id")
                game.setValue(name, forKey: "name")
                game.setValue(releaseDate, forKey: "releaseDate")
                game.setValue(rating, forKey: "rating")
                game.setValue(platforms, forKey: "platforms")
                game.setValue(genres, forKey: "genres")
                game.setValue(image, forKey: "image")
                game.setValue(playtime, forKey: "playtime")
                game.setValue(about, forKey: "about")
                do {
                    try taskContext.save()
                    completion()
                } catch let error {
                    print("Fail to save. \(error)")
                }
            }
        }
    }
    
    func deleteGame(_ id: Int, completion: @escaping() -> () ) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDGame")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            deleteRequest.resultType = .resultTypeCount
            if let deleteResult = try? taskContext.execute(deleteRequest)
                as? NSBatchDeleteResult,
                deleteResult.result != nil {
                completion()
            }
        }
    }
}
