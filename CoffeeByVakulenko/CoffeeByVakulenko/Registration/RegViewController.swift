//
//  RegistrationViewController.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 06.02.2024.
//  
//

import UIKit
import SnapKit


final class RegistrationViewController: UIViewController, RegistrationViewable {

    // MARK: - Public properties
    var presenter: RegistrationPresenterProtocol = RegistrationPresenter()

    // MARK: - Private properties
    private let baseView: UIView = {
        let view = UIView()
        return view
    }()

    private let borderView: UIView = {
        let stroke = UIView()
        stroke.layer.borderWidth = 0.5
        stroke.layer.borderColor = Colors.navBackLineColor.cgColor
        return stroke
    }()

    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFUIDisplay-Regular", size: 15)
        label.attributedText = NSMutableAttributedString(string: "e-mail", attributes: [NSAttributedString.Key.kern: -0.12])
        label.textColor = Colors.labelcolor
        return label
    }()
    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = Colors.backTextColor
        textField.placeholder = "example@example.ru"
        textField.font = UIFont(name: "SFUIDisplay-Regular", size: 18)
        textField.layer.borderColor = Colors.labelcolor.cgColor
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 24.5
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0,
                                                  width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }()
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.labelcolor
        label.font = UIFont(name: "SFUIDisplay-Regular", size: 15)
        label.attributedText = NSMutableAttributedString(string: "Пароль", attributes: [NSAttributedString.Key.kern: -0.12])
        return label
    }()
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = Colors.backTextColor
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = 24.5
        textField.layer.borderWidth = 2
        textField.layer.borderColor = Colors.labelcolor.cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0,
                                                  width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }()
    private lazy var passwordRetypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.labelcolor
        label.font = UIFont(name: "SFUIDisplay-Regular", size: 15)
        label.attributedText = NSMutableAttributedString(string: "Повторите пароль", attributes: [NSAttributedString.Key.kern: -0.12])
        return label
    }()
    private lazy var passwordRetypeField: UITextField = {
        let textField = UITextField()
        textField.textColor = Colors.backTextColor
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = 24.5
        textField.layer.borderWidth = 2
        textField.layer.borderColor = Colors.labelcolor.cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0,
                                                  width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }()
    private lazy var registrationButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 24.5
        button.layer.borderWidth = 2
        button.backgroundColor = Colors.buttonBackgroundColor
        button.titleLabel?.font = UIFont(name: "SFUIDisplay-Bold", size: 18)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("Регистрация", for: .normal)
        button.setTitleColor(Colors.buttonTitleOrCellBackGroundColor, for: .normal)
        button.contentVerticalAlignment = .center
        button.addTarget(self, action: #selector(registrationTapped(_:)), for: .touchUpInside)
        return button
    }()
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 24.5
        button.layer.borderWidth = 2
        button.backgroundColor = Colors.buttonBackgroundColor
        button.titleLabel?.font = UIFont(name: "SFUIDisplay-Bold", size: 18)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(Colors.buttonTitleOrCellBackGroundColor, for: .normal)
        button.contentVerticalAlignment = .center
        button.addTarget(self, action: #selector(loginTapped(_:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    private let userDefaults = CoffeeUserDefaults.shared


    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setUsernameIfRegisteredAndAuthentificatedEarlier()
        showRegisterOrLoginForm()
        navigationController?.navigationBar.tintColor = Colors.labelcolor
        navigationController?.navigationBar.backgroundColor = Colors.navBackColor
        navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18.0),
                NSAttributedString.Key.foregroundColor: Colors.labelcolor
            ]
    }

    // MARK: - Public methods
    func setupLoginView() {
        passwordRetypeLabel.isHidden = true
        passwordRetypeField.isHidden = true
        registrationButton.isHidden = true

        [borderView, emailLabel, usernameTextField, passwordLabel, passwordTextField, loginButton, Show.spinner].forEach { baseView.addSubview($0)}
        view.addSubview(baseView)
        view.backgroundColor = .white
        navigationItem.title = "Войти"
    }

    func loginLayout() {
        loginButton.isHidden = false
        baseView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        borderView.snp.makeConstraints { make in
            make.leading.equalTo(baseView)
            make.trailing.equalTo(baseView)
            make.top.equalTo(baseView)
            make.height.equalTo(2)
        }

        emailLabel.snp.makeConstraints { make in
            make.leading.equalTo(baseView).offset(18)
            make.trailing.equalTo(baseView)
            make.top.equalTo(baseView).offset(278)
            make.height.equalTo(18)
        }

        usernameTextField.snp.makeConstraints { make in
            make.leading.equalTo(baseView).offset(18)
            make.trailing.equalTo(baseView).inset(18)
            make.top.equalTo(emailLabel.snp.bottom).offset(10)
            make.height.equalTo(47)
        }

        passwordLabel.snp.makeConstraints { make in
            make.leading.equalTo(baseView).offset(18)
            make.trailing.equalTo(baseView)
            make.top.equalTo(baseView).offset(375)
            make.height.equalTo(18)
        }

        passwordTextField.snp.makeConstraints { make in
            make.leading.equalTo(baseView).offset(18)
            make.trailing.equalTo(baseView).inset(18)
            make.top.equalTo(passwordLabel.snp.bottom).offset(10)
            make.height.equalTo(47)
        }

        loginButton.snp.makeConstraints { make in
            make.leading.equalTo(baseView).offset(18)
            make.trailing.equalTo(baseView).inset(18)
            make.top.equalTo(baseView).offset(478)
            make.height.equalTo(47)
        }
    }

    func showRegistrationAlert() {
        let alertController = UIAlertController(title: "CoffeeByVakulenko", message: """
                Registration is successful!
                Ok-tap will start log in.
                """, preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: "Ок", style: .default) { [weak self] _ in
            self?.presenter.performLogin()
        }
        alertController.addAction(confirmAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Private methods
    private func setupRegistrationView() {
        [borderView, emailLabel, usernameTextField, passwordLabel, passwordTextField, passwordRetypeLabel, passwordRetypeField, registrationButton, Show.spinner].forEach{ baseView.addSubview($0)}
        view.addSubview(baseView)
        view.backgroundColor = .white
        navigationItem.title = "Регистрация"
    }

    private func showRegisterOrLoginForm() { //в зависимости регистрировался ли
        if let _ = userDefaults.isUsernameStored {
            setupLoginView()
            loginLayout()
        } else {
            setupRegistrationView()
            registrationLayout()
        }
    }

    private func registrationLayout() {
        baseView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        borderView.snp.makeConstraints { make in
            make.leading.equalTo(baseView).offset(0)
            make.trailing.equalTo(baseView)
            make.top.equalTo(baseView).offset(0)
            make.height.equalTo(2)
        }

        emailLabel.snp.makeConstraints { make in
            make.leading.equalTo(baseView).offset(18)
            make.trailing.equalTo(baseView)
            make.top.equalTo(baseView).offset(278)
            make.height.equalTo(18)
        }

        usernameTextField.snp.makeConstraints { make in
            make.leading.equalTo(baseView).offset(18)
            make.trailing.equalTo(baseView).inset(18)
            make.top.equalTo(emailLabel.snp.bottom).offset(10)
            make.height.equalTo(47)
        }

        passwordLabel.snp.makeConstraints { make in
            make.leading.equalTo(baseView).offset(18)
            make.trailing.equalTo(baseView)
            make.top.equalTo(baseView).offset(375)
            make.height.equalTo(18)
        }

        passwordTextField.snp.makeConstraints { make in
            make.leading.equalTo(baseView).offset(18)
            make.trailing.equalTo(baseView).inset(18)
            make.top.equalTo(passwordLabel.snp.bottom).offset(10)
            make.height.equalTo(47)
        }

        passwordRetypeLabel.snp.makeConstraints { make in
            make.leading.equalTo(baseView).offset(18)
            make.trailing.equalTo(baseView)
            make.top.equalTo(baseView).offset(472)
            make.height.equalTo(18)
        }

        passwordRetypeField.snp.makeConstraints { make in
            make.leading.equalTo(baseView).offset(18)
            make.trailing.equalTo(baseView).inset(18)
            make.top.equalTo(passwordRetypeLabel.snp.bottom).offset(10)
            make.height.equalTo(47)
        }

        registrationButton.snp.makeConstraints { make in
            make.leading.equalTo(baseView).offset(18)
            make.trailing.equalTo(baseView).inset(18)
            make.top.equalTo(baseView).offset(575)
            make.height.equalTo(47)
        }
    }

    // MARK: - Actions
    @objc private func registrationTapped(_ sender: UIButton){
        presenter.performRegister()
    }

    @objc private func loginTapped(_ sender: UIButton) {
        Show.spinner.startAnimating()
        presenter.performLogin()
    }

}


// MARK: - Configuration
extension RegistrationViewController: RegistrationViewConfigurable {

    var usernameText: String? { usernameTextField.text }
    var passwordText: String? { passwordTextField.text }

    func presetUsername(_ username: String?) {
        usernameTextField.text = username
    }
}

// MARK: - Error Handler
  extension RegistrationViewController: ErrorHandler {}
