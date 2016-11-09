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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            }
        }
    }
    
}
