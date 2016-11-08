//
//  SearchItemViewController.swift
//  BuyersNomorse
//
//  Created by Sabrina Ip on 11/8/16.
//  Copyright © 2016 Sabrina, Shashi. All rights reserved.
//

import UIKit

class SearchItemViewController: UIViewController, UITextFieldDelegate {
    
    //var searchResults: [SearchResults]?
    var searchItem = ""
    
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         APIRequestManager.manager.getData(endPoint: "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsAdvanced&SERVICE-VERSION=1.12.0&SECURITY-APPNAME=SabrinaI-GroupPro-PRD-dbff3fe44-d9ad0129&itemFilter(0).name=MaxPrice&itemFilter(0).value=7.50&itemFilter(1).name=MinPrice&itemFilter(1).value=7.50&paginationInput.entriesPerPage=10&categoryId=1281&keywords=cheap&RESPONSE-DATA-FORMAT=JSON") { (data: Data?) in
         if  let validData = data,
         let validSR = SearchResults.getDataFromJson(data: validData) {
         self.searchResults = validSR
         
         DispatchQueue.main.async {
         dump(self.searchResults)
         }
         }
         }
         */
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        guard let searchString = searchTextField.text else { return }
        searchItem = searchString
        //print(searchItem)
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
