import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var body: UILabel!
    var post: Post? {
        didSet {
            title.text = post?.title
            body.text = post?.body
        }
    }
}
