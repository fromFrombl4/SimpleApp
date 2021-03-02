import UIKit

class ViewController: UIViewController {
    @IBOutlet private(set) var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = "label"
    }
    @IBAction func buttonPressed(_ sender: UIButton) {
        let tabBarVC = UITabBarController()
        let feedVC = UINavigationController(
            rootViewController: FeedViewController(fetcher: Manager.shared)
        )
        let galleryVC = UINavigationController(rootViewController: GalleryViewController(fetcher: Manager.shared))

        feedVC.title = "Feed"
        galleryVC.title = "Gallery"

        tabBarVC.setViewControllers([feedVC, galleryVC], animated: true)

        guard let items = tabBarVC.tabBar.items else {
            return
        }

        let images = ["house", "star"]

        for x in 0..<items.count {
            items[x].image = UIImage(systemName: images[x])
        }
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: true, completion: nil)
    }
}
