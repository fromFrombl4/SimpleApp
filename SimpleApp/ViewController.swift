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
        static let username = "user"
        static let password = "password"
    }

    private var username: String?
    private var password: String?

    @IBAction func saveCredsSwitchChanged() {
        removeNamePasswordIfNeeded()
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

        usernameTextField.addTarget(
            self,
            action: #selector(updateUsernameProperty),
            for: .editingChanged
        )
        passwordTextField.addTarget(
            self,
            action: #selector(updatePasswordProperty),
            for: .editingChanged
        )
        restoreNamePasswordIfNeeded()
        restoreSwitchState()
    }

    private func removeNamePasswordIfNeeded() {
        let expression = !saveCredsSwitch.isOn
        if expression {
            UserDefaults.standard.removeObject(forKey: Constants.userNameKey)
            UserDefaults.standard.removeObject(forKey: Constants.passwordKey)
        }
    }

    private func saveNamePasswordIfNeeded() {
        let expression = saveCredsSwitch.isOn
        if expression {
            UserDefaults.standard.set(username, forKey: Constants.userNameKey)
            UserDefaults.standard.set(password, forKey: Constants.passwordKey)
        }
    }

    private func restoreNamePasswordIfNeeded() {
        if let isCheckedKey = UserDefaults.standard.value(forKey: Constants.isCheckedKey) as? Bool, isCheckedKey {
            restoreStoredNamePassword()
        }
    }

    func restoreStoredNamePassword() {
        usernameTextField.text = UserDefaults.standard.value(forKey: Constants.userNameKey) as? String
        passwordTextField.text = UserDefaults.standard.value(forKey: Constants.passwordKey) as? String
        updateUsernameProperty()
        updatePasswordProperty()
    }

    func restoreSwitchState() {
        saveCredsSwitch.isOn = (UserDefaults.standard.value(forKey: Constants.isCheckedKey) as? Bool) ?? false
    }

    private func showHomeController() {
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
    }

    private func showOopsAlert() {
        let alert = UIAlertController(title: "Oops!", message: "Your credentials are wrong", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    private func saveSwitchState() {
        UserDefaults.standard.set(saveCredsSwitch.isOn, forKey: Constants.isCheckedKey)
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        if username == Constants.username && password == Constants.password {
            saveNamePasswordIfNeeded()
            saveSwitchState()
            showHomeController()
        } else {
            showOopsAlert()
        }
    }

    @objc func updateUsernameProperty() {
        print(usernameTextField.text as Any)
        username = usernameTextField.text
    }

    @objc func updatePasswordProperty() {
        print(passwordTextField.text as Any)
        password = passwordTextField.text
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
