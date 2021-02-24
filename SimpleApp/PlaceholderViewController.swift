import UIKit
enum Constants {
    static let noDataImage = UIImage(named: "no_data")
}
protocol PlaceholderViewControllerDelegate: AnyObject {
    func buttonPressed()
}
class PlaceholderViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!

    weak var delegate: PlaceholderViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor, constant: 100
            ),
            button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 100),
            button.topAnchor.constraint(equalTo: label.bottomAnchor),
            button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 100),
            label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 100),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 100),
            imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 100),
            imageView.topAnchor.constraint(equalTo: self.view.topAnchor)
        ])
        label.textAlignment = .justified
        label.center = self.view.center
        imageView.image = UIImage(named: "no_data")
        self.view.addSubview(imageView)
        button.setTitle("Tap", for: .normal)
        label.text = "Oops! There is no any data!"
    }

    @IBAction func pressedButton(_ sender: UIButton) {
        self.delegate?.buttonPressed()
    }
}
