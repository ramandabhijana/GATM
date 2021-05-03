//
//  ViewController.swift
//  GATM
//
//  Created by Abhijana Agung Ramanda on 10/07/20.
//  Copyright © 2020 Abhijana Agung Ramanda. All rights reserved.
//

import UIKit

private enum State {
    case loading
    case empty
    case error(Error)
    case populated([Game])
    case paging([Game], next: Int)
    
    var currentGames: [Game] {
        switch self {
        case .paging(let games, _):
            return games
        case .populated(let games):
            return games
        default:
            return []
        }
    }
}

class GameListViewController: UIViewController {
    // MARK: - Properties
    private var searchController = UISearchController(searchResultsController: nil)
    private let networkingService = NetworkingService()
    var navigationItemTitle: String?
    
    private var state = State.loading {
        didSet {
            setFooterView()
            tableView.reloadData()
        }
    }
    var baseUrlComponents = URLComponents()
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noneView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = navigationItemTitle
        navigationItem.hidesSearchBarWhenScrolling = false
        configureSearchBar()
        configureTableView()
        loadGames()
    }
    
    // MARK: - Methods
    
    // Untuk update state dari View Controller
    func update(response: GamesResult) {
        if let error = response.error {
            state = .error(error)
            return
        }
        guard
            let newGames = response.games,
            !newGames.isEmpty
            else { state = .empty; return }
        
        var allGames = state.currentGames
        allGames.append(contentsOf: newGames)
        
        state = response.hasMorePages ?
            .paging(allGames, next: response.currentPage + 1) :
            .populated(allGames)
    }
    
    func loadPage(_ page: Int) {
        baseUrlComponents.queryItems?
            .append(URLQueryItem(name: "page", value: String(page)))
        if let query = searchController.searchBar.text,
            query.count > 0 {
            baseUrlComponents.queryItems?
                .append( URLQueryItem(name: "search", value: query) )
        }
        networkingService.getGames(urlComponents: baseUrlComponents, page: page, onCompletion: { [weak self] response in
            guard let self = self else { return }
            self.searchController.searchBar.endEditing(true)
            self.update(response: response)
        })
    }
    
    func loadGames() {
        state = .loading
        loadPage(1)
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        let nib = UINib(nibName: GameTableViewCell.NibName, bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: GameTableViewCell.ReuseIdentifier)
    }
    
    func setFooterView() {
        switch state {
        case .populated:
            tableView.tableFooterView = nil
        case .paging:
            tableView.tableFooterView = loadingView
        case .loading:
            tableView.tableFooterView = loadingView
        case .error(let error):
            errorLabel.text = error.localizedDescription
            tableView.tableFooterView = errorView
        case .empty:
            tableView.tableFooterView = noneView
        }
    }
}


// MARK: - TableViewDataSource
extension GameListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state.currentGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =
            tableView.dequeueReusableCell(withIdentifier: GameTableViewCell.ReuseIdentifier) as? GameTableViewCell
            else { return UITableViewCell() }
    
        cell.game = state.currentGames[indexPath.row]
        
        // Apabila state saat ini adalah paging dan
        // row yang akan ditampilkan punya index yang sama
        // dgn hasil terakhir dalam currentGames array
        if case .paging(_, let nextPage) = state,
            indexPath.row == state.currentGames.count - 1 {
            loadPage(nextPage)
        }
        return cell
    }
}


// MARK: - TableViewDelegate
extension GameListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        guard
            let cell = tableView.cellForRow(at: indexPath) as? GameTableViewCell,
            let game = cell.game
            else { return }

        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "GameDetailViewController")
            as? GameDetailViewController
            else { return }
        
        detailVC.game = game
        
        navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - SearchBar
extension GameListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadGames()
    }
    
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
}

