import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
    private enum Constants {
        static let titleHeight: CGFloat = 40
        static let labelPadding: CGFloat = 16
    }

    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var body: UILabel!

    @IBOutlet private weak var titleHeight: NSLayoutConstraint!
    @IBOutlet private weak var titleLeading: NSLayoutConstraint!
    @IBOutlet private weak var titleTrailing: NSLayoutConstraint!
    @IBOutlet private weak var bodyTop: NSLayoutConstraint!
    @IBOutlet private weak var bodyTrailing: NSLayoutConstraint!
    @IBOutlet private weak var bodyLeading: NSLayoutConstraint!
    @IBOutlet private weak var bodyHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()

        titleHeight.constant = Constants.titleHeight
        titleLeading.constant = Constants.labelPadding
        titleTrailing.constant = Constants.labelPadding
        bodyTop.constant = Constants.labelPadding
        bodyTrailing.constant = Constants.labelPadding
        bodyLeading.constant = Constants.labelPadding
    }

    var post: Post? {
        didSet {
            title.text = post?.title
            body.text = post?.body

            guard let body = post?.body else {
                return
            }

            let height = FeedCollectionViewCell.height(for: body)
            bodyHeight.constant = height
            setNeedsUpdateConstraints()
        }
    }

    static func cellSize(for body: String) -> CGSize {
        return CGSize(
            width: UIScreen.main.bounds.width - Constants.labelPadding * 2,
            height: height(for: body) + Constants.titleHeight + Constants.labelPadding * 2
        )
    }

    private static func height(for body: String) -> CGFloat {
        let constraintRect = CGSize(
            width: UIScreen.main.bounds.width - Constants.labelPadding * 2,
            height: .greatestFiniteMagnitude
        )

        let result = body
            .boundingRect(
                with: constraintRect,
                options: [.usesLineFragmentOrigin],
                attributes: [.font: UIFont.systemFont(ofSize: 17)],
                context: nil
            )
        return ceil(result.size.height)
    }
}
