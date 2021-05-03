//
//  FavGameViewController.swift
//  GATM
//
//  Created by Abhijana Agung Ramanda on 20/07/20.
//  Copyright © 2020 Abhijana Agung Ramanda. All rights reserved.
//

import UIKit

private enum State {
    case searching
    case normal
}

class FavGameViewController: UIViewController {
    @IBOutlet weak var gameTableView: UITableView!
    
    private var state: State = .normal
    private var searchController = UISearchController(searchResultsController: nil)
    private var games = [GameModel]()
    private lazy var gameProvider = {
        return GameProvider()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        navigationItem.hidesSearchBarWhenScrolling = false
        
        gameTableView.delegate = self
        gameTableView.dataSource = self
        
        let nib = UINib(nibName: GameTableViewCell.NibName, bundle: .main)
        gameTableView.register(nib, forCellReuseIdentifier: GameTableViewCell.ReuseIdentifier)
    }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    switch state {
    case .normal:
        loadAllGames()
    case .searching:
        loadGames()
    }
  }
    
    private func loadAllGames() {
        state = .normal
        gameProvider.fetchAllGames { result in
            DispatchQueue.main.async {
                self.games = result
                UIView.transition(with: self.gameTableView,
                                  duration: 0.35,
                                  options: .transitionCrossDissolve,
                                  animations: { self.gameTableView.reloadData() })
            }
        }
    }
    
    @objc private func loadGames() {
        state = .searching
        let query = searchController.searchBar.text!
        gameProvider.fetchGame(byName: query) { [weak self] results in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.games = results
                UIView.transition(with: self.gameTableView,
                                  duration: 0.35,
                                  options: .transitionCrossDissolve,
                                  animations: { self.gameTableView.reloadData() })
            }
        }
    }
}

extension FavGameViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let cell = tableView.cellForRow(at: indexPath) as? GameTableViewCell,
            let gameModel = cell.gameModel,
            let detailVC = storyboard?.instantiateViewController(withIdentifier: "GameDetailViewController")
                as? GameDetailViewController
            else { return }
        
        let game = Game.init(byConverting: gameModel)
        detailVC.game = game
        detailVC.thumbnailImage = UIImage(data: gameModel.image!)
        
        navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FavGameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =
            tableView.dequeueReusableCell(withIdentifier: GameTableViewCell.ReuseIdentifier) as? GameTableViewCell
            else { return UITableViewCell() }
        cell.gameModel = games[indexPath.row]
        return cell
    }
    
}

extension FavGameViewController: UISearchBarDelegate {
    func configureSearchBar() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.autocorrectionType = .no
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .white
        
        let whiteTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let textFieldInSearchBar = UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        textFieldInSearchBar.defaultTextAttributes = whiteTitleAttributes
        
        navigationItem.searchController = searchController
        searchController.searchBar.becomeFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(loadGames),
                                               object: nil)
        perform(#selector(loadGames), with: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadAllGames()
    }
}
