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
//    var facebookUserProfileImageView: UIImageView!
//    var facebookUserNameLabel: UILabel!
    
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
//        
//        facebookUserProfileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
//        facebookUserProfileImageView.center = CGPoint(x: view.center.x, y: 200)
//        facebookUserProfileImageView.image = UIImage(named: "fb-art.jpg")
//        view.addSubview(facebookUserProfileImageView)
//        
//        facebookUserNameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
//        facebookUserNameLabel.center = CGPoint(x: view.center.x, y: 300)
//        facebookUserNameLabel.text = "Not Logged In"
//        facebookUserNameLabel.textAlignment = NSTextAlignment.center
//        view.addSubview(facebookUserNameLabel)
//        
//        
//        self.navigationItem.titleView = facebookUserProfileImageView
//        
//        
//        getFacebookUserInfo()

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
//        facebookUserProfileImageView.image = UIImage(named: "fb-art.jpg")
//        facebookUserNameLabel.text = "Not Logged In"
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
//        getFacebookUserInfo()
        print("Successfully logged in with facebook...")
        
    }
//
//    
//    func getFacebookUserInfo() {
//        if(FBSDKAccessToken.current() != nil)
//        {
//            //print permissions, such as public_profile
//            print(FBSDKAccessToken.current().permissions)
//            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, email"])
//            let connection = FBSDKGraphRequestConnection()
//            
//            connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
//                
//                let data = result as! [String : AnyObject]
//                
//                self.facebookUserNameLabel.text = data["name"] as? String
//                
//                let FBid = data["id"] as? String
//                
//                let url = NSURL(string: "https://graph.facebook.com/\(FBid!)/picture?type=large&return_ssl_resources=1")
//                self.facebookUserProfileImageView.image = UIImage(data: NSData(contentsOf: url! as URL)! as Data)
//            })
//            connection.start()
//        }
//    }
    
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
