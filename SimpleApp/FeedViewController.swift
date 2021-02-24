import UIKit

class FeedViewController: UIViewController {
    private enum Constants {
        static let cellReuseIdentifier = "cellReuseIdentifier"
        static let loadingCellIdentifier = "loadingCellIdentifier"
        static let batchSize = 20
        static let paginationLoadingOffset = 1
        static let cellHeight: CGFloat = 100
    }
    @IBOutlet weak var collection: UICollectionView!
    private var feedArray: [Int] = []
    private var refreshControl = UIRefreshControl()
    private var isLoading = false
    private var isEmptyServerResponse: Bool = false
    private var isFirstLoading: Bool = true
    private var isLoadingCell = LoadingIndicatorCollectionViewCell()
    private var placeHolderController = PlaceholderViewController.init()
    private var loadingFailedAlert = UIAlertController(
        title: "Oops! Something went wrong",
        message: "Please press the button and try again!",
        preferredStyle: .alert
    )
    weak var delegate: PlaceholderViewControllerDelegate?

    private func setupCollection() {
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
        let collectionLayout = collection.collectionViewLayout as? UICollectionViewFlowLayout
        collectionLayout?.itemSize = CGSize(width: UIScreen.main.bounds.width, height: Constants.cellHeight)
        collectionLayout?.minimumLineSpacing = 0
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        collection.addSubview(refreshControl)
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

    private func setupAlert() {
        loadingFailedAlert.addAction(UIAlertAction(title: "Try Again", style: .default) {_ in
            self.loadingFailedAlert.view.removeFromSuperview()
        })
        self.present(loadingFailedAlert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        setupPlaceHolder()
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
                    self?.isFirstLoading = false
                    self?.feedArray = feed
                    self?.isEmptyServerResponse = false
                    self?.collection.reloadData()
                case .failure:
                    self?.placeHolderController.view.isHidden = false

                    if self?.isFirstLoading == false && self?.isEmptyServerResponse == true {
                        self?.setupAlert()
                    }
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
            guard let cell = collection.dequeueReusableCell(
                withReuseIdentifier: Constants.loadingCellIdentifier,
                for: indexPath
            ) as? LoadingIndicatorCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
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
        }
    }
}

extension FeedViewController: PlaceholderViewControllerDelegate {
    func buttonPressed() {
        self.placeHolderController.view.removeFromSuperview()
        self.setupCollection()
    }
}
