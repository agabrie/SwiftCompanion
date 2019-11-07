//
//  ViewController.swift
//  SwiftyCompanion
//
//  Created by abduraghmaan GABRIELS on 2019/11/06.
//  Copyright © 2019 abduraghmaan GABRIELS. All rights reserved.
//

import UIKit
class AlertHelper {
//    ALERT_MESSAGE
    func showAlert(fromController controller: UIViewController, messages: String) {
        let alert = UIAlertController(title: "Error", message: messages, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
}
class ViewController: UIViewController {

    @IBOutlet weak var txfUsername: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
    
    let client = Client()
    let conn:APIConnection = APIConnection()
    
    @IBAction func SearchClick(_ sender: Any) {
        let loadIcon = loadingIconStart()
        if txfUsername.text! != "" {
            //BEGIN LOGIN PROCESS
            loginUser(input: txfUsername.text!)
            sleep(2)
            if (client.userFirstName != "") {
                self.loadLoggedInScreen()
            }
            else {
                let alert = AlertHelper()
                alert.showAlert(fromController: self, messages: "Invalid username")
            }
        }
        else {
            let alert = AlertHelper()
            alert.showAlert(fromController: self, messages: "Empty Fields")
        }
        loadingIconStop(activityIndicator: loadIcon)
    }
    func loginUser(input: String) {
        if input == "" {
            print("No username entered")
            return
        }
        else {
           print("User is \(input)")
        }

        //get token
        conn.genTok{ (token) in
            print("Token is \(token)")
            //user requests in here with token
            self.client.getUserInfo(token: token, username: "\(input)") { firstName,lastName,login,photo,userLevel, cursusNames,cursusLevels  in
                print("User found with Firstname: \(firstName), Lastname: \(lastName), Login: \(login) Photo: \(photo) Userlevel: \(userLevel), CursusNames: \(cursusNames), CursusLevels: \(cursusLevels)")
            }
        }
    }
    override func viewDidLoad() {
            super.viewDidLoad()
            txfUsername.text = ""
//            passwdTextField.text = ""
    //        if UIDevice.current.orientation.isLandscape {}
        }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
//    @IBAction func SearchClick(_ sender: Any) {
//        getInfo(){
//
//        }
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    func loadingIconStart () -> UIActivityIndicatorView {
            let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
            activityIndicator.color = UIColor.white
            activityIndicator.center = CGPoint(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height/2)
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            return activityIndicator
        }

    //    Stops Icon Load
        func loadingIconStop(activityIndicator: UIActivityIndicatorView) {
            activityIndicator.stopAnimating()
        }

    //    Loads Logged In Screen
        func loadLoggedInScreen() {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let userViewController = storyBoard.instantiateViewController(withIdentifier: "UserViewController") as! UserViewController
            userViewController.clientlogged = client
            userViewController.connection = conn
            self.navigationController?.pushViewController(userViewController, animated: true)
    //        self.present(loggedInViewController, animated: true, completion: nil)
        }
    
}
