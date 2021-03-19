import UIKit
import Kingfisher
import Hex

class GalleryCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(cgColor: CGColor(red: 0, green: 2, blue: 3, alpha: 0.3))
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let imageView: UIImageView = {
        let imageV = UIImageView()
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()

    let label: UILabel = {
        let labelV = UILabel()
        labelV.backgroundColor = UIColor(hex: "#ef000")
        labelV.translatesAutoresizingMaskIntoConstraints = false
        labelV.numberOfLines = 0
        return labelV
    }()

    override func prepareForReuse() { // очистить ячейку до первоначального состояния
        super.prepareForReuse()
        label.isHidden = false
        label.text = nil
        imageView.image = nil
    }

    var splashImage: SplashImage? {
        didSet {
            label.text = splashImage?.altDescription
            label.isHidden = label.text == nil
            guard let splashImage = splashImage, let url = URL(string: splashImage.urls.regular) else {
                imageView.image = nil
                return
            }
            imageView.kf.setImage(with: url)
        }
    }

    private func addSubView() {
        addSubview(imageView)
        addSubview(label)

        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 2).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 2).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: 2).isActive = true

        label.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 10).isActive = true
        label.leftAnchor.constraint(equalTo: self.imageView.leftAnchor, constant: 10).isActive = true
        label.rightAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: -10).isActive = true
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
