import UIKit

class FeedViewController: UIViewController {
    private enum Constants {
        static let cellReuseIdentifier = "cellReuseIdentifier"
        static let loadingCellIdentifier = "loadingCellIdentifier"
        static let retryCellIdentifier = "retryCellIdentifier"
        static let batchSize = 20
        static let paginationLoadingOffset = 1
        static let cellHeight: CGFloat = 100
    }
    @IBOutlet weak var collection: UICollectionView!
    private var feedArray: [Int] = []
    private var refreshControl = UIRefreshControl()
    private var isLoading = false
    private var isFirstLoading = true
    private var isEmptyServerResponse = false
    private var isFailedOnPagination = false
    private var paginationRetryAction: (() -> Void)?
    private var placeHolderController = PlaceholderViewController()
    weak var delegate: PlaceholderViewControllerDelegate?

    private func setupCollection() {
        placeHolderController.delegate = self
        collection.delegate = self
        collection.dataSource = self
        collection.register(
            UINib(
                nibName: String.init(describing: FeedCollectionViewCell.self
                ), bundle: nil
            ), forCellWithReuseIdentifier: Constants.cellReuseIdentifier
        )
        collection.register(
            UINib(
                nibName: String.init(describing: LoadingIndicatorCollectionViewCell.self
                ), bundle: nil
            ), forCellWithReuseIdentifier: Constants.loadingCellIdentifier
        )
        collection.register(
            UINib(
                nibName: String.init(describing: RetyCollectionViewCell.self
                ), bundle: nil
            ), forCellWithReuseIdentifier: Constants.retryCellIdentifier
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
        setupPlaceHolder()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }

    @objc func refresh(_ sender: AnyObject) {
        print(#function)
        isLoading = true
        Manager.shared
            .loadItems(offset: 0, limit: Constants.batchSize) { [weak self] result in
                self?.isLoading = false
                self?.refreshControl.endRefreshing()
                switch result {
                case .success(let feed):
                    self?.isFirstLoading = false
                    self?.feedArray = feed
                    self?.isEmptyServerResponse = false
                    self?.collection.reloadData()
                case .failure:
                    self?.placeHolderController.view.isHidden = false
                    self?.collection.reloadData()
                }
            }
    }

    private func setupPlaceHolder() {
        view.addSubview(placeHolderController.view)
        NSLayoutConstraint.activate([
            placeHolderController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            placeHolderController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            placeHolderController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            placeHolderController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        placeHolderController.view.isHidden = true
    }

    private func refreshData() {
        refreshControl.beginRefreshing()
        refreshControl.sendActions(for: .valueChanged)
    }

    private func paginationLoading(offset: Int, limit: Int = Constants.batchSize) {
        isLoading = true
        Manager.shared
            .loadItems(offset: offset, limit: limit) { [weak self] result in
                self?.isLoading = false
                switch result {
                case .success(let feed):
                    self?.isEmptyServerResponse = feed.isEmpty
                    self?.feedArray.append(contentsOf: feed)
                    self?.collection.reloadData()
                    self?.isFailedOnPagination = false
                case .failure:
                    self?.isFailedOnPagination = true
                    print("error")
                    self?.collection.reloadData()
                }
            }
    }
}

extension FeedViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if isEmptyServerResponse || isFirstLoading {
            return feedArray.count
        } else {
            return feedArray.count + 1
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if indexPath.row == feedArray.count {
            if isFailedOnPagination {
                guard let cell = collection.dequeueReusableCell(
                    withReuseIdentifier: Constants.retryCellIdentifier,
                    for: indexPath
                ) as? RetyCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.retryAction = nil
                cell.retryAction = { [weak self] in
                    guard let self = self else {
                        return
                    }
                    self.isFailedOnPagination = false
                    self.collection.reloadData()
                    self.paginationLoading(offset: self.feedArray.count)
                }
                return cell
            } else {
                guard let cell = collection.dequeueReusableCell(
                    withReuseIdentifier: Constants.loadingCellIdentifier,
                    for: indexPath
                ) as? LoadingIndicatorCollectionViewCell else {
                    return UICollectionViewCell()
                }
                return cell
            }
        } else {
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
            && isEmptyServerResponse == false
            && isFailedOnPagination == false {
            print(indexPath.row)
            paginationLoading(offset: feedArray.count)
        }
    }
}

extension FeedViewController: PlaceholderViewControllerDelegate {
    func buttonPressed() {
        placeHolderController.view.isHidden = true
        refreshData()
    }
}
