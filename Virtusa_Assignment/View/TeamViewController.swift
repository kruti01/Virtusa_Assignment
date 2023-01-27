//
//  TeamViewController.swift
//  Virtusa_Assignment
//
//  Created by Kruti on 25/01/23.
//

import UIKit
import Network

enum TeamSection: CaseIterable {
        case all
    }

protocol TeamDetegate: AnyObject {
    func doneButton(selectedTeam: String?)
}

typealias TableViewDataSource = UITableViewDiffableDataSource<TeamSection, TeamCellViewModel>
typealias TableViewSnapshot = NSDiffableDataSourceSnapshot<TeamSection, TeamCellViewModel>

class TeamViewController: UIViewController {
    
    weak var delegate : TeamDetegate?
    let activityView =  UIActivityIndicatorView(style: .large)
    var networkCheck = NetworkCheck.sharedInstance()
    private var dataSource : TableViewDataSource!
    private var snapshot : TableViewSnapshot!
    
    let statusBarHeight: CGFloat = {
        var heightToReturn: CGFloat = 0.0
        for window in UIApplication.shared.windows {
            if let height = window.windowScene?.statusBarManager?.statusBarFrame.height, height > heightToReturn {
                heightToReturn = height
            }
        }
        return heightToReturn
    }()
    
    lazy var teamViewModel = {
        TeamsViewModel()
    }()
    
    // MARK: - Outlets
    lazy var navigationBar: UINavigationBar = {
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: statusBarHeight, width: screenSize.width, height: 44))
        navBar.barTintColor =  UIColor(red: 95/255, green: 158/255, blue: 160/255, alpha: 1)
        navBar.isTranslucent = false
        navBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        let navItem = UINavigationItem(title: "Teams")
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: #selector(done))
        doneItem.tintColor = .white
        navItem.rightBarButtonItem = doneItem
        navBar.setItems([navItem], animated: false)
        return navBar
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.register(TeamTableViewCell.self, forCellReuseIdentifier: CellIdentifier.teamTableViewCell)
        return tableView
    }()
  
    // MARK: - Done button click
    @objc func done() {
        self.delegate?.doneButton(selectedTeam: teamViewModel.selectedTeam)
        self.navigationController?.popViewController(animated: true)
    }
  
    // MARK: - configure method
    func configure(delegate : TeamDetegate?, selectedTeam: String?) {
        self.delegate=delegate
        teamViewModel.selectedTeam = selectedTeam ?? ""
    }
    
    // MARK: - View controller lifecycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor(red: 95/255, green: 158/255, blue: 160/255, alpha: 1)
        view.addSubview(navigationBar)
        view.addSubview(tableView)
        addConstraints()
        configureTableViewDataSource()
        if networkCheck.currentStatus == .satisfied {
            initTeamViewModel()
        } else {
            getDataFromDatabase()
        }
        networkCheck.addObserver(observer: self)
    }
    
    // MARK: - Add constraints method
    func addConstraints() {
        let screenSize: CGRect = UIScreen.main.bounds
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo:navigationBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: screenSize.height - (navigationBar.frame.height + statusBarHeight))
        ])
    }
    
    // MARK: - Tableview datasource configure method
    private func configureTableViewDataSource() {
        dataSource = TableViewDataSource(tableView: tableView, cellProvider: { tableView, indexPath, model in
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.teamTableViewCell, for: indexPath) as! TeamTableViewCell
            cell.configure(teamDetails: model, selectedTeam: self.teamViewModel.selectedTeam)
            return cell
        })
        tableView.dataSource = dataSource
    }
    
    // MARK: - Snapshot method
    func applySnapshot() {
        snapshot = TableViewSnapshot()
        snapshot.appendSections([.all])
        snapshot.appendItems(teamViewModel.teamCellViewModels)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - Initialize team view model and get teams data
    func initTeamViewModel() {
        showActivityIndicator(withActivityView: activityView)
        teamViewModel.getTeamsDetails {
            self.hideActivityIndicator(activityView: self.activityView)
            self.applySnapshot()
        }
    }
    
    // MARK: - Get data from database
    func getDataFromDatabase() {
        let teamsData = DatabaseHandler.shared.fetch(TeamsData.self)
        if teamsData.count > 0 {
            teamViewModel.getDataFromDatabase(teams: teamsData) {
                applySnapshot()
            }
        } else {
            showAlertWith(title: "No Data Available.", message: "")
        }
    }
}

// MARK: - Tableview delegate methods
extension TeamViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        teamViewModel.selectTeamAt(index: indexPath.row)
        self.tableView.reloadData()
    }
}

// MARK: - Network status change method
extension TeamViewController: NetworkCheckObserver {
    func statusDidChange(status: NWPath.Status) {
        if status == .satisfied {
            if teamViewModel.teamCellViewModels.count > 0 {
                applySnapshot()
            } else {
                initTeamViewModel()
            }
        }else if status == .unsatisfied {
            getDataFromDatabase()
        }
    }
}
