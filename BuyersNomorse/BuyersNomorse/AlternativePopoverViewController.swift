//
//  AlternativePopoverViewController.swift
//  BuyersNomorse
//
//  Created by Madushani Lekam Wasam Liyanage on 11/10/16.
//  Copyright © 2016 Sabrina, Shashi. All rights reserved.
//

import UIKit

class AlternativePopoverViewController: UIViewController, UIPopoverControllerDelegate {
    
    @IBOutlet weak var popoverImage: UIImageView!
    
    @IBOutlet weak var popoverLabel: UILabel!
    
    var alternativeItem: SearchResults?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popoverLabel.text = alternativeItem?.categoryName
        
        guard let alternativeItemsExists = alternativeItem else { return }
        
        if let image = alternativeItemsExists.galleryUrl {
            APIRequestManager.manager.getData(endPoint: image) { (data: Data?) in
                if  let validData = data,
                    let validImage = UIImage(data: validData) {
                    DispatchQueue.main.async {
                        self.popoverImage.image = validImage
                    }
                }
            }
        }
        
        ////if let alternativeItemURL = URL(string: item.viewItemUrl) {
        ////                UIApplication.shared.open(alternativeItemURL)
        ////            }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func prepareForReuse() {
        popoverImage.image = nil
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
