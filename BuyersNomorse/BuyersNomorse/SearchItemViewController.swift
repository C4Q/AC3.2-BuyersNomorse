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
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        if let searchString = searchTextField.text {
            searchItem = searchString
            print(searchItem)
             performSegue(withIdentifier: "SegueToResultsViewController", sender: searchItem)
        }
        
       
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueToResultsViewController" {
            if let destinationVC = segue.destination as? ResultsViewController {
                destinationVC.searchedItem = searchItem
            }
            
        }
    }
    
    
}
