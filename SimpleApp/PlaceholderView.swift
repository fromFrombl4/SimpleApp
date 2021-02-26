import UIKit

protocol PlaceholderViewDelegate: AnyObject {
    func placeholderViewButtonPressed()
}

class PlaceholderView: UIView {
    private let imageView = UIImageView()
    private let label = UILabel()
    private let button = UIButton()

    weak var delegate: PlaceholderViewDelegate?

    init() {
        super.init(frame: .zero)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        setupViewHierarchy()
        setupLayout()
        setupElements()
    }

    private func setupViewHierarchy() {
        addSubview(label)
        addSubview(imageView)
        addSubview(button)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 100),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            NSLayoutConstraint(
                item: imageView,
                attribute: .height,
                relatedBy: .equal,
                toItem: imageView,
                attribute: .width,
                multiplier: 1,
                constant: 0
            )
        ])

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 100),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            label.heightAnchor.constraint(equalToConstant: 40)
        ])

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 100),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupElements() {
        backgroundColor = .white
        label.textAlignment = .center
        label.text = "Oops! There is no any data!"
        imageView.image = UIImage(named: "no_data")
        button.setTitle("Tap", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(pressedButton), for: .touchUpInside)
    }

    @objc private func pressedButton() {
        delegate?.placeholderViewButtonPressed()
    }
}
