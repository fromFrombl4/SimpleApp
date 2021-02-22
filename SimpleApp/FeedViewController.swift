import UIKit

class FeedViewController: UIViewController {
    private enum Constants {
        static let cellReuseIdentifier = "cellReuseIdentifier"
        static let batchSize = 20
        static let paginationLoadingOffset = 3
        static let cellHeight: CGFloat = 100
    }
    @IBOutlet weak var collection: UICollectionView!
    private var feedArray: [Int] = []
    private var refreshControl = UIRefreshControl()
    private var isLoading = false
    private var isEmptyServerResponse: Bool = false

    private func setupCollection() {
        collection.delegate = self
        collection.dataSource = self
        collection.register(
            UINib(
                nibName: String.init(describing: FeedCollectionViewCell.self
                ), bundle: nil
            ), forCellWithReuseIdentifier: Constants.cellReuseIdentifier
        )
        let collectionLayout = collection.collectionViewLayout as? UICollectionViewFlowLayout
        collectionLayout?.itemSize = CGSize(width: UIScreen.main.bounds.width, height: Constants.cellHeight)
        collectionLayout?.minimumLineSpacing = 0
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        collection.addSubview(refreshControl)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
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
                    self?.collection.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
    }
}

extension FeedViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        feedArray.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collection.dequeueReusableCell(
            withReuseIdentifier: Constants.cellReuseIdentifier,
            for: indexPath
        ) as? FeedCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.label.text = "\(feedArray[indexPath.row])"
        return cell
    }
}

extension FeedViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        let indexToLoad = feedArray.count - Constants.paginationLoadingOffset
        if indexPath.row == indexToLoad
            && isLoading == false
            && isEmptyServerResponse == false {
            print(indexPath.row)
            isLoading = true
            Manager.shared
                .loadItems(offset: feedArray.count, limit: Constants.batchSize) { [weak self] result in
                    self?.isLoading = false
                    switch result {
                    case .success(let feed):
                        self?.isEmptyServerResponse = feed.isEmpty
                        self?.feedArray.append(contentsOf: feed)
                        self?.collection.reloadData()
                    case .failure(let error):
                        print(error)
                    }
                }
        } else if  isEmptyServerResponse == true {
            let controller = PlaceholderViewController()
            self.present(controller, animated: true, completion: nil)
        }
    }
}
