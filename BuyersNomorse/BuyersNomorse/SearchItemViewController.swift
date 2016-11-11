//
//  SearchItemViewController.swift
//  BuyersNomorse
//
//  Created by Sabrina Ip on 11/8/16.
//  Copyright © 2016 Sabrina, Shashi. All rights reserved.
//

import UIKit

class SearchItemViewController: UIViewController, UITextFieldDelegate {
    
    var searchItem = ""
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var ebayLogoImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ebayLogoImageView.image = #imageLiteral(resourceName: "ebay-logo-Transparent-download-png")
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        guard let searchString = searchTextField.text else { return }
        searchItem = searchString
        guard searchItem != "" else { return }
        performSegue(withIdentifier: "SegueToResultsViewController", sender: searchItem)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueToResultsViewController" {
            if let destinationVC = segue.destination as? ResultsViewController {
                destinationVC.searchedItem = searchItem
                destinationVC.title = "Results for: \(String(searchItem.characters.first!).capitalized + String(searchItem.characters.dropFirst()))"
            }
        }
    }
    
}
