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
    
    let APIEndPoint1 = "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsAdvanced&SERVICE-VERSION=1.12.0&SECURITY-APPNAME=Madushan-GroupPro-PRD-4bff3fe44-23206160"
    let minPriceKey2 = "&itemFilter(0).name=MaxPrice&itemFilter(0).value="
    let maxPriceKey3 = "&itemFilter(1).name=MinPrice&itemFilter(1).value="
    let APIEndP4 = "&paginationInput.entriesPerPage=25"
    let keyWordsKey5 = "&keywords="
    let APIEndP6 = "&RESPONSE-DATA-FORMAT=JSON"
    
    var searchedItem: String?
    var itemSelected: SearchResults?
    var items: [SearchResults]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func minPriceChanged(_ sender: UITextField) {
    }
    @IBAction func maxPriceChanged(_ sender: UITextField) {
    }

    @IBAction func doneButtonTapped(_ sender: UIButton) {
        
        if let minPriceString = minPriceTextField.text, let maxPriceString = maxPriceTextField.text {
            minPrice = minPriceString
            maxPrice = maxPriceString
            print(minPrice)
            print(maxPrice)
        }
      
 
        
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
