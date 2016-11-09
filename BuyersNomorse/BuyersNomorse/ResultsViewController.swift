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
        let keywordInput = self.searchedItem.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        var webAddress = "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsAdvanced&SERVICE-VERSION=1.12.0&SECURITY-APPNAME=SabrinaI-GroupPro-PRD-dbff3fe44-d9ad0129&RESPONSE-DATA-FORMAT=JSON&paginationInput.entriesPerPage=25&keywords=\(keywordInput)"
        if let maxPriceEntered = self.maxPrice {
            webAddress += "&itemFilter(0).name=MaxPrice&itemFilter(0).value=\(maxPriceEntered)"
        }
        if let minPriceEntered = self.minPrice {
            webAddress += "&itemFilter(1).name=MinPrice&itemFilter(1).value=\(minPriceEntered)"
        }
        return webAddress
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
    
    @IBAction func minPriceChanged(_ sender: UITextField) {
    }
    @IBAction func maxPriceChanged(_ sender: UITextField) {
    }
    
    /*
     Int(minString)! and Int(maxString)! can cause an error
     when user enters something other than a number, or an empty string.
     Need to guard against those cases first
        -Also, should we allow for it to search if only one number is entered? (ex. max  is 10, min is not entered)
     */
    
//    func isMinMaxFieldCheckPassed() -> Bool {
//        var check = false
//        //couldn't find a way to cast as a double
//        if let minString = minPriceTextField.text, let maxString = maxPriceTextField.text {
//            if Int(minString)! < Int(maxString)! {
//                check = true
//            }
//            else {
//                check = false
//            }
//        }
//        return check
//    }
    
    func minMaxAreAcceptableAnswers() -> Bool {
        var minPDouble: Double?
        var maxPDouble: Double?
        
        minPrice = nil
        maxPrice = nil
        
        if minPriceTextField.text! != "" {
            guard let minNum = Double(minPriceTextField.text!) else {
                //print("minPrice field is not a num: \(minPriceTextField.text!)")
                errorLabel.text = "The minimum price is not a valid answer"
                return false
            }
            minPDouble = minNum
            minPrice = String(minNum)
        }
        
        if maxPriceTextField.text! != "" {
            guard let maxNum = Double(maxPriceTextField.text!) else {
                //print("maxPrice field is not a num: \(maxPriceTextField.text!)")
                errorLabel.text = "The maximum price is not a valid answer"
                return false
            }
            maxPDouble = maxNum
            maxPrice = String(maxNum)
        }

        if let minExists = minPDouble, let maxExists = maxPDouble {
            guard minExists < maxExists else {
                errorLabel.text = "Minimum should be less than Maximum"
                return false
            }
        }
        
        print("min price is \(minPrice)")
        print("MAX price is \(maxPrice)")
        return true
    }


    @IBAction func doneButtonTapped(_ sender: UIButton) {
        print("min price textfield is showing \(minPriceTextField.text)")
        print("MAX price textfield is showing \(maxPriceTextField.text)")
        
        guard minMaxAreAcceptableAnswers() else {
            errorLabel.isHidden = false
            return
        }
        errorLabel.isHidden = true
        print("The endpoint is currently \(self.endpoint)")
        loadData()
        
        /* The error appears in that min price can't be entered without a max price
            -Can we do any JSON manipulation so that we can do this?
            -Otherwise, we'll need to change code, where we only accept if both min and max are enetered
            -JSON parsing error for one example I tried - update SearchResults.swift to be more robust-
                    http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsAdvanced&SERVICE-VERSION=1.12.0&SECURITY-APPNAME=SabrinaI-GroupPro-PRD-dbff3fe44-d9ad0129&RESPONSE-DATA-FORMAT=JSON&paginationInput.entriesPerPage=25&keywords=wor&itemFilter(0).name=MaxPrice&itemFilter(0).value=30.0&itemFilter(1).name=MinPrice&itemFilter(1).value=20.0
        */
        
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
        
        /* Temporary, need to update a custom ResultsTableViewCell, images and stuff */
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.currentPrice
        return cell
    }
//    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        print("At this point, self.items is this:")
//        print(self.items)
//        itemSelected = self.items?[indexPath.row]
//        print("At this point, itemSelected is \(itemSelected)")
//        print("It should be the same as \(self.items?[indexPath.row])")
//        performSegue(withIdentifier: "SegueToAlternativeViewController", sender: ResultsTableViewCell.self)
//    }
//    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueToAlternativeViewController" {
            if let cell = sender as? ResultsTableViewCell {
                if let destinationVC = segue.destination as? AlternativeChoicesViewController {
                    if let indexPath = self.tableView.indexPath(for: cell) {
                    itemSelected = self.items?[indexPath.row]
                    destinationVC.customerSelection = itemSelected
                    print("*************************")
                    print(itemSelected)
                    print("*************************")
                    }
                }
            }
        }
    }
    
    
}
