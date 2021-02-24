import UIKit

class LoadingIndicatorCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    override func prepareForReuse() {
        super.prepareForReuse()
        indicator.startAnimating()
    }
}
