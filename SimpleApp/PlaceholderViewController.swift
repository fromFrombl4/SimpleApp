import UIKit
enum Constants {
    static let noDataImage = UIImage(named: "no_data")
}
class PlaceholderViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
//        NSLayoutConstraint.activate([
//            button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 100),
//            button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 100),
//            button.topAnchor.constraint(equalTo: label.bottomAnchor),
//            button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
//        ])
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = UIImage(named: "no_data")
        self.view.addSubview(imageView)
        button.setTitle("Tap", for: .normal)
        label.text = "Oops! There is no any data!"
    }
    @IBAction func pressedButton(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }
}
