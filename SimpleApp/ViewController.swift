import UIKit

class ViewController: UIViewController {
    @IBOutlet private(set) var label: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var saveCredsSwitch: UISwitch!
    @IBOutlet weak var savePasswordLabel: UILabel!

    private enum Constants {
        static let userNameKey = "userNameKey"
        static let passwordKey = "passwordKey"
        static let isCheckedKey = "isCheckedKey"

        //simulate API user
        static let username = "user"
        static let password = "password"
    }

    private var username: String? = nil
    private var password: String? = nil
    private var isChecked = false

    @IBAction func saveCredsSwitchChanged() {
        //update UD isCheckedKey

        //if OFF
        // remove userNameKey & passwordKey
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        label.text = "SimpleApp"
        label.textAlignment = .center
        button.setTitle("Sign In", for: .normal)
        savePasswordLabel.text = "Save credentials"
        saveCredsSwitch.isOn = false

        usernameTextField.addTarget(
            self,
            action: #selector(usernameTextFieldChanged),
            for: .editingChanged
        )
        passwordTextField.addTarget(
            self,
            action: #selector(passwordTextFieldChanged),
            for: .editingChanged
        )

        setupLayout()

        restoreNamePasswordIfNeeded()
    }

    func restoreNamePasswordIfNeeded() {
        if let isCheckedKey = UserDefaults.standard.value(forKey: Constants.isCheckedKey) as? Bool, isCheckedKey {
            restoreStoredNamePassword()
        }
    }

    func restoreStoredNamePassword() {
        //set fields
        //update switch
    }

    private func setupLayout() {
        saveCredsSwitch.translatesAutoresizingMaskIntoConstraints = false
        savePasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false

        label.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200).isActive = true
        label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50).isActive = true
        label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50).isActive = true
        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
        usernameTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50).isActive = true
        usernameTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 10).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        saveCredsSwitch.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive = true
        saveCredsSwitch.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        saveCredsSwitch.bottomAnchor.constraint(equalTo: button.topAnchor, constant: 10).isActive = true
        savePasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive = true
        savePasswordLabel.leadingAnchor.constraint(equalTo: saveCredsSwitch.trailingAnchor, constant: 10).isActive = true
        savePasswordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        savePasswordLabel.bottomAnchor.constraint(equalTo: button.topAnchor, constant: 10).isActive = true
        button.topAnchor.constraint(equalTo: savePasswordLabel.bottomAnchor, constant: 10).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true

    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        if username == Constants.username && password == Constants.password {
            //if swiftch ON save user&pass to UD


            let tabBarVC = UITabBarController()
            let feedVC = UINavigationController(
                rootViewController: FeedViewController(fetcher: Manager.shared)
            )
            let galleryVC = UINavigationController(
                rootViewController: GalleryViewController(fetcher: SplashImageFetcher())
            )
            feedVC.title = "Feed"
            galleryVC.title = "Gallery"
            tabBarVC.setViewControllers([feedVC, galleryVC], animated: true)
            guard let items = tabBarVC.tabBar.items else {
                return
            }
            let images = ["house", "star"]
            for x in 0..<items.count {
                items[x].image = UIImage(systemName: images[x])
            }
            tabBarVC.modalPresentationStyle = .fullScreen
            present(tabBarVC, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Oops!", message: "Your credentials are wrong", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    @objc func usernameTextFieldChanged() {
        print(usernameTextField.text)
    }

    @objc func passwordTextFieldChanged() {
        print(passwordTextField.text)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
