import UIKit

class ViewController: UIViewController {
    @IBOutlet private(set) var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = "label"
    }
}
