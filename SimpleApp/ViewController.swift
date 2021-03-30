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
        if saveCredsSwitch.isOn == false {
            UserDefaults.standard.removeObject(forKey: Constants.userNameKey)
            UserDefaults.standard.removeObject(forKey: Constants.passwordKey)
        }
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
        if saveCredsSwitch.isOn {
            username = UserDefaults.standard.object(forKey: Constants.userNameKey) as? String
            password = UserDefaults.standard.object(forKey: Constants.passwordKey) as? String
        }
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        if username == Constants.username && password == Constants.password {
            //if swiftch ON save user&pass to UD
            if saveCredsSwitch.isOn {
                UserDefaults.standard.set(username, forKey: Constants.userNameKey)
                UserDefaults.standard.set(password, forKey: Constants.passwordKey)
            }

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
