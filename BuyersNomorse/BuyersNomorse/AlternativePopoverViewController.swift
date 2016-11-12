//
//  AlternativePopoverViewController.swift
//  BuyersNomorse
//
//  Created by Madushani Lekam Wasam Liyanage on 11/10/16.
//  Copyright © 2016 Sabrina, Shashi, Erica. All rights reserved.
//

import UIKit

class AlternativePopoverViewController: UIViewController, UIPopoverControllerDelegate {
    
    @IBOutlet weak var imageButton: UIButton!
    
    @IBOutlet weak var alternativeItemNameLabel: UILabel!
    @IBOutlet weak var alternativeItemPriceLabel: UILabel!
    
    var itemImage: String?
    
    
    var alternativeItem: SearchResults?
    
    @IBAction func alternativeItemImageButtonTapped(_ sender: UIButton) {
        if let alternativeItemURL = URL(string: (alternativeItem?.viewItemUrl)!) {
            UIApplication.shared.open(alternativeItemURL)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        alternativeItemNameLabel.text = alternativeItem?.categoryName
        
        if let itemPrice = alternativeItem?.currentPrice {
            alternativeItemPriceLabel.text = ("$ \(itemPrice)")
        }
        
        guard let alternativeItemsExists = alternativeItem else { return }
        
        if let plusImage = alternativeItemsExists.galleryPlusPictureUrl {
            itemImage = plusImage
            
        }
        else if let smallImage = alternativeItem?.galleryUrl {
            itemImage = smallImage
        }
        
        if let image = itemImage {
            APIRequestManager.manager.getData(endPoint: image) { (data: Data?) in
                if  let validData = data,
                    let validImage = UIImage(data: validData) {
                    DispatchQueue.main.async {
                        self.imageButton.setBackgroundImage(validImage, for: UIControlState.normal)
                    }
                }
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func prepareForReuse() {
        self.imageButton.imageView?.image = nil
    }
    
    
}
