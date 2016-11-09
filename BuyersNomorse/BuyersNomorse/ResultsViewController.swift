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
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var errorLabel: UILabel!
    var minPrice: String?
    var maxPrice: String?
    var searchedItem = ""
    
    var endpoint: String {
        return constructEndpoint(minPrice: self.minPrice, maxPrice: self.maxPrice)
    }
    
    var itemSelected: SearchResults?
    var items: [SearchResults]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        APIRequestManager.manager.getData(endPoint: self.endpoint) { (data: Data?) in
            if  let validData = data {
                self.items = SearchResults.getDataFromJson(data: validData)
            }
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
    
    func constructEndpoint(minPrice: String?, maxPrice: String?) -> String {
        let keywordInput = self.searchedItem.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        var endpoint = "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsAdvanced&SERVICE-VERSION=1.12.0&SECURITY-APPNAME=SabrinaI-GroupPro-PRD-dbff3fe44-d9ad0129&RESPONSE-DATA-FORMAT=JSON&paginationInput.entriesPerPage=25&keywords=\(keywordInput)"
        
        if let maxPriceEntered = maxPrice {
            endpoint += "&itemFilter(0).name=MaxPrice&itemFilter(0).value=\(maxPriceEntered)"
        }
        
        if let minPriceEntered = minPrice {
            endpoint += "&itemFilter(1).name=MinPrice&itemFilter(1).value=\(minPriceEntered)"
        }
        
        return endpoint
    }
    
    
    @IBAction func minPriceChanged(_ sender: UITextField) {
    }
    @IBAction func maxPriceChanged(_ sender: UITextField) {
    }
    
    func isMinMaxFieldCheckPassed() -> Bool {
        var check = false
        //couldn't find a way to cast as a double
        if let minString = minPriceTextField.text, let maxString = maxPriceTextField.text {
            if Int(minString)! < Int(maxString)! {
                check = true
            }
            else {
                check = false
            }
        }
        return check
    }
    
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        
        if isMinMaxFieldCheckPassed() {
            
            errorLabel.isHidden = true
            
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
        }
            
        else {
            errorLabel.isHidden = false
            errorLabel.text = "Minimum should be less than Maximum"
        }
        // Need to figure out how to guard min price < max price
        // Need to update tableview to new prices
    }
    
    // MARK: - TABLEVIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let itemsExists = items else { return 0 }
        return itemsExists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! ResultsTableViewCell
        guard let itemsExists = items else { return cell }
        let item = itemsExists[indexPath.row]
        
        // Temporary, need to update a custom ResultsTableViewCell, images and stuff
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.currentPrice
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
