//
//  MainViewController.swift
//  GATM
//
//  Created by Abhijana Agung Ramanda on 19/07/20.
//  Copyright © 2020 Abhijana Agung Ramanda. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    static let sectionHeaderElementKind = "section-header-element-kind"
    
    enum Section: String, CaseIterable {
        case featured = "Featured"
        case platforms = "Top Platforms"
        case genres = "Genres"
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, CollectionItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, CollectionItem>
    
    var itemsCollectionView: UICollectionView!
    var dataSource: DataSource!
    private var searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !MyProfile.isLoggedIn {
            guard let createVC = storyboard?.instantiateViewController(identifier: "CreateScene")
            as? EditProfileViewController
            else { return }
            navigationController?.pushViewController(createVC, animated: true)
        }
        
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        configureSearchBar()
        configureCollectionView()
        configureDataSource()
    }
}

extension MainViewController
{
    func generateLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let isWideView = layoutEnvironment.container.effectiveContentSize.width > 500
            
            let sectionLayoutKind = Section.allCases[sectionIndex]
            switch sectionLayoutKind {
            case .featured:
                return self.generateFeaturedLayout(isWide: isWideView)
            case .platforms:
                return self.generatePlatformsLayout()
            case .genres:
                return self.generateGenresLayout(isWide: isWideView)
            }
        }
    }
    
    func configureCollectionView() {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.register(HeaderView.self,
                                forSupplementaryViewOfKind: MainViewController.sectionHeaderElementKind,
                                withReuseIdentifier: HeaderView.reuseIdentifier)
        collectionView.register(FeaturedItemCell.self,
                                forCellWithReuseIdentifier: FeaturedItemCell.reuseIdentifer)
        collectionView.register(PlatformItemCell.self,
                                forCellWithReuseIdentifier: PlatformItemCell.reuseIdentifier)
        collectionView.register(GenreItemCell.self,
                                forCellWithReuseIdentifier: GenreItemCell.reuseIdentifier)
        itemsCollectionView = collectionView
    }
    
    func configureDataSource() {
        dataSource = DataSource(collectionView: itemsCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, collectionItem: CollectionItem) -> UICollectionViewCell? in
            let sectionType = Section.allCases[indexPath.section]
            
            switch sectionType {
            case .featured:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: FeaturedItemCell.reuseIdentifer,
                    for: indexPath) as? FeaturedItemCell
                    else { fatalError() }
                cell.image = collectionItem.itemImage
                cell.title = collectionItem.itemTitle
                return cell
                
            case .platforms:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PlatformItemCell.reuseIdentifier,
                    for: indexPath) as? PlatformItemCell
                    else { fatalError() }
                cell.image = collectionItem.itemImage
                cell.title = collectionItem.itemTitle
                return cell
                
            case .genres:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: GenreItemCell.reuseIdentifier,
                    for: indexPath) as? GenreItemCell
                    else { fatalError() }
                cell.image = collectionItem.itemImage
                cell.title = collectionItem.itemTitle
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = {
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderView.reuseIdentifier,
                for: indexPath) as? HeaderView
                else { fatalError() }
            supplementaryView.label.text = Section.allCases[indexPath.section].rawValue
            return supplementaryView
        }
        
        let snapshot = snapshotForCurrentState()
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func generateFeaturedLayout(isWide: Bool) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .fractionalWidth(2/3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupFractionalWidth = isWide ? 0.475 : 0.95
        let groupFractionalHeight: Float = isWide ? 1/3 : 2/3
        let groupSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(CGFloat(groupFractionalWidth)),
          heightDimension: .fractionalWidth(CGFloat(groupFractionalHeight)))
        let group = NSCollectionLayoutGroup.horizontal(
          layoutSize: groupSize,
          subitem: item,
          count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(
          top: 5,
          leading: 5,
          bottom: 5,
          trailing: 5)

        let headerSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: headerSize,
          elementKind: MainViewController.sectionHeaderElementKind,
          alignment: .top)

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .groupPaging

        return section
    }
    
    func generatePlatformsLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .fractionalWidth(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
          widthDimension: .absolute(130),
          heightDimension: .absolute(166))
        let group = NSCollectionLayoutGroup.vertical(
          layoutSize: groupSize,
          subitem: item,
          count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(
          top: 5,
          leading: 5,
          bottom: 5,
          trailing: 5)

        let headerSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: headerSize,
          elementKind: MainViewController.sectionHeaderElementKind,
          alignment: .top)

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .groupPaging

        return section
    }
    
    func generateGenresLayout(isWide: Bool) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

        let groupHeight = NSCollectionLayoutDimension.fractionalWidth(isWide ? 0.25 : 0.5)
        let groupSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: groupHeight)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: isWide ? 4 : 2)
        
        let headerSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: headerSize,
          elementKind: MainViewController.sectionHeaderElementKind,
          alignment: .top)
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }
    
    func snapshotForCurrentState() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([.featured])
        snapshot.appendItems(featuredItems)
        
        snapshot.appendSections([.platforms])
        snapshot.appendItems(platformItems)
        
        snapshot.appendSections([.genres])
        snapshot.appendItems(genreItems)
        
        return snapshot
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard
            let item = dataSource.itemIdentifier(for: indexPath),
            let gameListVC = storyboard?.instantiateViewController(identifier: "GameListViewController")
                as? GameListViewController
            else { return }
        gameListVC.navigationItemTitle = item.itemTitle
        gameListVC.baseUrlComponents = item.urlComponents
        navigationController?.pushViewController(gameListVC, animated: true)
    }
}

extension MainViewController: UISearchBarDelegate {
    func configureSearchBar() {
      if #available(iOS 13.0, *) {
        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.searchTextField.backgroundColor = UIColor.black.withAlphaComponent(0.1)
      }
      
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let gameListVC = storyboard?.instantiateViewController(identifier: "GameListViewController")
            as? GameListViewController
            else { return }
        let components = NetworkingService.generateURLComponents(withQueryItems: [
            URLQueryItem(name: "search", value: searchBar.text)
        ])
        gameListVC.baseUrlComponents = components!
        
        navigationController?.pushViewController(gameListVC, animated: true)
    }
}
