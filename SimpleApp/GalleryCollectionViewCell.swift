import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageV = UIImageView()
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()

    private func addSubView() {
        addSubview(imageView)

        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 2).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 2).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: 2).isActive = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(cgColor: CGColor(red: 0, green: 2, blue: 3, alpha: 0.3))
        addSubView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
