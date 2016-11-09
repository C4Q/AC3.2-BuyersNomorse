//
//  ResultsViewController.swift
//  BuyersNomorse
//
//  Created by Sabrina Ip on 11/8/16.
//  Copyright © 2016 Sabrina, Shashi. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var minPriceTextField: UITextField!
    @IBOutlet weak var maxPriceTextField: UITextField!
    
    var minPrice: String?
    var maxPrice: String?
    var searchedItem = ""
    
    func constructEndpoint(keyword: String, minPrice: String?, maxPrice: String?) -> String {
        let keywordInput = keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        var endpoint = "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsAdvanced&SERVICE-VERSION=1.12.0&SECURITY-APPNAME=SabrinaI-GroupPro-PRD-dbff3fe44-d9ad0129&RESPONSE-DATA-FORMAT=JSON&paginationInput.entriesPerPage=25&keywords=\(keywordInput)"
        
        if let maxPriceEntered = maxPrice {
            endpoint += "&itemFilter(0).name=MaxPrice&itemFilter(0).value=\(maxPriceEntered)"
        }
        
        if let minPriceEntered = minPrice {
            endpoint += "&itemFilter(1).name=MinPrice&itemFilter(1).value=\(minPriceEntered)"
        }
        
        return endpoint
    }
    
    var itemSelected: SearchResults?
    var items: [SearchResults]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(constructEndpoint(keyword: searchedItem, minPrice: nil, maxPrice: nil))
    }
    
    @IBAction func minPriceChanged(_ sender: UITextField) {
    }
    @IBAction func maxPriceChanged(_ sender: UITextField) {
    }

    @IBAction func doneButtonTapped(_ sender: UIButton) {
        if minPriceTextField.text! != "" {
            guard let minNum = Double(minPriceTextField.text!)
                else {
                    print("minPrice field is not a num: \(minPriceTextField.text!)")
                    return
                }
            minPrice = String(minNum)
        }
        
        if maxPriceTextField.text! != "" {
            guard let maxNum = Double(maxPriceTextField.text!)
                else {
                    print("maxPrice field is not a num: \(maxPriceTextField.text!)")
                    return
                }
            maxPrice = String(maxNum)
        }
        
        print("min price is \(minPrice)")
        print("max price is \(maxPrice)")
        
        // Need to figure out how to guard min price < max price
    }
 

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 //critics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! ResultsTableViewCell
//        let critic = critics[indexPath.row]
//        cell.criticNameLabel.text = critic.name
      //  cell.textLabel?.text = "Hello"

        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        itemSelected = self.items?[indexPath.row]
        performSegue(withIdentifier: "SegueToAlternativeViewController", sender: itemSelected)
    }
    

    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueToAlternativeViewController" {
            if let destinationVC = segue.destination as? AlternativeChoicesViewController {
                destinationVC.customerSelection = itemSelected
            }
            
        }
     }
    
   
}
