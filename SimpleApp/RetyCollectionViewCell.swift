import UIKit

class RetyCollectionViewCell: UICollectionViewCell {
    var retryAction: (() -> Void)?

    @IBAction private func pressedRetryButton(_ sender: Any) {
        retryAction?()
    }
}
