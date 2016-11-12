//
//  SearchItemViewController.swift
//  BuyersNomorse
//
//  Created by Sabrina Ip on 11/8/16.
//  Copyright © 2016 Sabrina, Shashi, Erica. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class SearchItemViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {
    
    var searchItem = ""
    
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var ebayLogoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ebayLogoImageView.image = #imageLiteral(resourceName: "logopng")
        searchButton.layer.cornerRadius = 5
        
        //http://studyswift.blogspot.com/2016/01/facebook-sdk-and-swift-create-facebook.html
        let loginButton = FBSDKLoginButton()
        loginButton.center = CGPoint(x: view.center.x, y: 650)
        view.addSubview(loginButton)
        loginButton.delegate = self

    }
    
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        guard let searchString = searchTextField.text else { return }
        searchItem = searchString
        guard searchItem != "" else { return }
        performSegue(withIdentifier: "SegueToResultsViewController", sender: searchItem)
    }
    
    //https://videos.letsbuildthatapp.com/playlist/Firebase-Social-Login/video/Facebook-Authentication-and-Cocoapods
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        print("Successfully logged in with facebook...")
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueToResultsViewController" {
            if let destinationVC = segue.destination as? ResultsViewController {
                destinationVC.searchedItem = searchItem
                destinationVC.title = "\(String(searchItem.characters.first!).capitalized + String(searchItem.characters.dropFirst()))"
            }
        }
    }
    
}
