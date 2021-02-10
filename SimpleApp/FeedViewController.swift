//
//  FeedViewController.swift
//  SimpleApp
//
//  Created by Roman Dod on 2/8/21.
//

import UIKit

class FeedViewController: UIViewController {
    private enum Constants {
        static let cellReuseIdentifier = "cellReuseIdentifier"
        static let batchSize = 20
        static let paginationLoadingOffset = 3
    }
    @IBOutlet weak var table: UITableView!
    var feedArray: [Int] = []
    var refreshControl = UIRefreshControl()
    var isLoading = false
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellReuseIdentifier)
        table.tableFooterView = UIView()

        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        table.addSubview(refreshControl)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isLoading = true
        Manager.shared.loadItems(offset: 0, limit: Constants.batchSize) { [weak self] result in
            self?.isLoading = false
            self?.feedArray = result
            self?.table.reloadData()
        }
    }
    @objc func refresh(_ sender: AnyObject) {
        table.reloadData()
        refreshControl.endRefreshing()
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        feedArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = table.dequeueReusableCell(withIdentifier: Constants.cellReuseIdentifier) else {
            return UITableViewCell()
        }
        cell.textLabel?.text = "\(feedArray[indexPath.row])"
        return cell
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let indexToLoad = feedArray.count - Constants.paginationLoadingOffset
        if indexPath.row == indexToLoad && isLoading == false {
            print(indexPath.row)
            isLoading = true
            Manager.shared.loadItems(offset: feedArray.count, limit: Constants.batchSize) { [weak self] result in
                self?.isLoading = false
                self?.feedArray.append(contentsOf: result)
                self?.table.reloadData()
            }
        }
    }
}
