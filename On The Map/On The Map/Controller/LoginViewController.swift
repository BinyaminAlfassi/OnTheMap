//
//  LoginViewController.swift
//  On The Map
//
//  Created by Binyamin Alfassi on 17/09/2020.
//  Copyright © 2020 Binyamin Alfassi. All rights reserved.
//

import UIKit


// This view controller is for login screet
class LoginViewController: UIViewController {
    //MARK: Outlets
    // Text Fields
    @IBOutlet weak var usernameTextField: LoginTextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    // Login Button
    @IBOutlet weak var loginButton: LoginButton!
    // Activity indicator
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: ViewController Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // This function will set the text of textfields to be an empty string
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.text = ""
        passwordTextField.text = ""

    }
    
    // This function will set "Portrait" as the only option for this screen
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //MARK: Actions
    // This function will be invoked once login button is tapped. A request to login will be sent by Udavity Client
    @IBAction func loginTapped(_ sender: Any) {
        setLoggingIn(true)
        UdacityClient.createSessionId(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "", completion: handdleSessionIdResponse(success:error:))
    }
    // This function handles the response of creating a session in login process
    func handdleSessionIdResponse(success: Bool, error: Error?) {
        if success {
            print(UdacityClient.Auth.sessionId)
            // If success -> allow user to continue
            self.performSegue(withIdentifier: "completeLoginSegue", sender: nil)
        } else {
            if let error = error {
                ShowLoginFailure(message: error.localizedDescription)
            }
        }
        setLoggingIn(false)
    }
    
    // This function set the UI according to login state.
    // if Login state -> Disable all UI and start activity indicator
    // if not login   -> Enable all UI and stop activity indicator
    func setLoggingIn(_ isLoggingIn: Bool) {
        if isLoggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        usernameTextField.isEnabled = !isLoggingIn
        passwordTextField.isEnabled = !isLoggingIn
        self.loginButton.isEnabled = !isLoggingIn
    }
    
    // This function present a faluite notice on the screen
    func ShowLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
}
