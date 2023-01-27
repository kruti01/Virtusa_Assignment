//
//  HomeViewController.swift
//  Virtusa_Assignment
//
//  Created by Kruti on 24/01/23.
//

import UIKit
import Foundation
import AVKit
//import CoreData
import Network

enum Section: Int, CaseIterable {
    case previous
    case upcoming
}

typealias DataSource = UICollectionViewDiffableDataSource<Section, MatchCellViewModel>
typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MatchCellViewModel>


class HomeViewController: UIViewController {
    
    
    private var dataSource : DataSource!
    private var snapshot : Snapshot!
    let activityView =  UIActivityIndicatorView(style: .large)
    var networkCheck = NetworkCheck.sharedInstance()
    let database = DatabaseHandler.shared

    lazy var viewModel = {
        MatchesViewModel()
    }()
    
    var topSafeArea: CGFloat{
        get{
            var topSafeArea: CGFloat
            if #available(iOS 11.0, *) {
                topSafeArea = view.safeAreaInsets.top
            } else {
                topSafeArea = topLayoutGuide.length
            }
            return topSafeArea
        }
    }
    
    let statusBarHeight: CGFloat = {
        var heightToReturn: CGFloat = 0.0
        for window in UIApplication.shared.windows {
            if let height = window.windowScene?.statusBarManager?.statusBarFrame.height, height > heightToReturn {
                heightToReturn = height
            }
        }
        return heightToReturn
    }()
   
    // MARK: - Outlets
    lazy var navigationBar: UINavigationBar = {
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: statusBarHeight, width: screenSize.width, height: 44))
        navBar.barTintColor =  UIColor(red: 95/255, green: 158/255, blue: 160/255, alpha: 1)
        navBar.isTranslucent = false
        let navItem = UINavigationItem(title: "Matches")
        navBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        let barButton = UIBarButtonItem(customView: filterButton)
        navItem.rightBarButtonItem = barButton
        navBar.setItems([navItem], animated: false)
        return navBar
    }()
    
    lazy var baseView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.register(MatchDetailsCollectionViewCell.self, forCellWithReuseIdentifier: CellIdentifier.matchDetailsCollectionViewCell)
        collectionView.register(MatchDetailsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CellIdentifier.headerView)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    lazy var filterButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        button.setImage(UIImage(named: "filter"), for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .white
        button.addTarget(self, action: #selector(filterButtonClick), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Folter button click
    @objc func filterButtonClick() {
        let teamVC = TeamViewController()
        teamVC.configure(delegate: self, selectedTeam: viewModel.selectedTeam)
        self.navigationController?.pushViewController(teamVC, animated: true)
    }
    
    // MARK: - View controller lifecycle method
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 95/255, green: 158/255, blue: 160/255, alpha: 1)
        self.navigationController?.isNavigationBarHidden = true
        self.view.addSubview(navigationBar)
        self.view.addSubview(baseView)
        baseView.addSubview(collectionView)

        addConstraints()
        configureCollectionViewDataSource()
        configureHeader()
        
        if networkCheck.currentStatus == .satisfied {
            initViewModel()
        } else {
            getDataFromDatabase()
        }
        networkCheck.addObserver(observer: self)
    }
    
    // MARK: - Add constraints
    func addConstraints() {
        let guide = self.view.safeAreaLayoutGuide
        let screenSize: CGRect = UIScreen.main.bounds
        NSLayoutConstraint.activate([
            baseView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            baseView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            baseView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            baseView.heightAnchor.constraint(equalToConstant: screenSize.height - (navigationBar.frame.height + statusBarHeight)),
            collectionView.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: baseView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: baseView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: baseView.bottomAnchor)
        ])
    }
    

    
    // MARK: - Collectionview datasource configure methods
    private func configureCollectionViewDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.matchDetailsCollectionViewCell, for: indexPath) as! MatchDetailsCollectionViewCell
            cell.configure(matchDetails: model, delegate: self)
            cell.backgroundColor = .white
            return cell
        })
        collectionView.dataSource = dataSource
        
    }
    
    func configureHeader() {
        dataSource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CellIdentifier.headerView, for: indexPath) as! MatchDetailsHeaderView
            header.label.attributedText = NSAttributedString(string: indexPath.section == 0 ? "Previous Matches" : "Upcoming Matches", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
            return header
        }
    }
    
    // MARK: - Snapshot method
    func applySnapshot(previousMatches: [MatchCellViewModel], upcomingMatches: [MatchCellViewModel]) {
        snapshot = Snapshot()
        snapshot.appendSections([.previous,.upcoming])
        snapshot.appendItems(previousMatches, toSection: .previous)
        snapshot.appendItems(upcomingMatches, toSection: .upcoming)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
   

    
    // MARK: - initialize view module and get data
    func initViewModel() {
        showActivityIndicator(withActivityView: activityView)
        viewModel.getMatchesDetails {
            self.hideActivityIndicator(activityView: self.activityView)
            self.applySnapshot(previousMatches: (self.viewModel.previousMatchCellViewModels), upcomingMatches: (self.viewModel.upcomingMatchCellViewModels))
        }
    }
    
    // MARK: - Get data from database
    func getDataFromDatabase() {
        let matchesData = DatabaseHandler.shared.fetch(MatchesData.self)
        if matchesData.count > 0 {
            viewModel.getDataFromDatabase(matches: matchesData) {
                self.applySnapshot(previousMatches: (self.viewModel.previousMatchCellViewModels), upcomingMatches: (self.viewModel.upcomingMatchCellViewModels))
            }
        } else {
            showAlertWith(title: "No Data Available.", message: "")
        }
    }
}

// MARK: - Match Details Cell Detegate
extension HomeViewController: MatchDetailsCellDetegate {
    func highlightsButtonClick(selectedURLString: String) {
        playVideo(urlString: selectedURLString)
    }
    
    func playVideo(urlString: String) {
        let videoURL = URL(string: urlString)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
}

// MARK: - Collectionview delegate methods
extension HomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 40.0)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
            self.collectionView.collectionViewLayout.prepare()
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
}

// MARK: - Collectionview flowlayout delegate
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 1
        let padding:CGFloat = 20
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - padding
        let itemHeight = 200.0
        //        collectionView.bounds.height - (2 * padding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

// MARK: - Team controller done button click delegate
extension HomeViewController: TeamDetegate {
    func doneButton(selectedTeam: String?) {
        if let selectedTeam = selectedTeam, !selectedTeam.isEmpty {
            viewModel.showSelectedTeamMatches(selectedTeam: selectedTeam)
            self.applySnapshot(previousMatches: (self.viewModel.previousMatchCellViewModels), upcomingMatches: (self.viewModel.upcomingMatchCellViewModels))
            
        } else {
            viewModel.showAllTeamsMatches()
            self.applySnapshot(previousMatches: (self.viewModel.previousMatchCellViewModels), upcomingMatches: (self.viewModel.upcomingMatchCellViewModels))
        }
    }
}

// MARK: - Network status change method
extension HomeViewController: NetworkCheckObserver {
    func statusDidChange(status: NWPath.Status) {
        if status == .satisfied {
            if viewModel.upcomingMatchCellViewModels.count > 0 || viewModel.previousMatchCellViewModels.count > 0 {
                applySnapshot(previousMatches: viewModel.previousMatchCellViewModels, upcomingMatches: viewModel.upcomingMatchCellViewModels)
            } else {
                initViewModel()
            }
        }else if status == .unsatisfied {
            getDataFromDatabase()
        }
    }
}




