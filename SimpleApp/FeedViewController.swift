import UIKit

class FeedViewController: UIViewController {
    private enum Constants {
        static let cellReuseIdentifier = "cellReuseIdentifier"
        static let batchSize = 20
        static let paginationLoadingOffset = 3
    }
    @IBOutlet weak var table: UITableView!
    private var feedArray: [Int] = []
    private var refreshControl = UIRefreshControl()
    private var isLoading = false
    private var isEmptyServerResponse: Bool = false

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
        refreshControl.beginRefreshing()
        refreshControl.sendActions(for: .valueChanged)
    }

    @objc func refresh(_ sender: AnyObject) {
        isLoading = true
        Manager.shared
            .loadItems(offset: 0, limit: Constants.batchSize) { [weak self] result in
                self?.isLoading = false
                self?.refreshControl.endRefreshing()
                switch result {
                case .success(let feed):
                    self?.feedArray = feed
                    self?.table.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
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
        if indexPath.row == indexToLoad && isLoading == false && isEmptyServerResponse == false {
            print(indexPath.row)
            isLoading = true
            Manager.shared
                .loadItems(offset: feedArray.count, limit: Constants.batchSize) { [weak self] result in
                    self?.isLoading = false
                    switch result {
                    case .success(let feed):
                        self?.isEmptyServerResponse = feed.isEmpty
                        self?.feedArray.append(contentsOf: feed)
                        self?.table.reloadData()
                    case .failure(let error):
                        print(error)
                    }
                }
        }
    }
}
