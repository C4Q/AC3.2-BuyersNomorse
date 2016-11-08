//
//  AlternativeChoicesViewController.swift
//  BuyersNomorse
//
//  Created by Sabrina Ip on 11/8/16.
//  Copyright © 2016 Sabrina, Shashi. All rights reserved.
//

import UIKit

class AlternativeChoicesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 //reviews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlternativeChoice", for: indexPath) as! AlternativeChoicesCollectionViewCell
//        let review = reviews[indexPath.row]
//        cell.movieTitleLabel.text = review.movie
//        
//        if let existingImage = review.image {
//            APIRequestManager.manager.getData(endpoint: (existingImage.link)) { (data: Data?) in
//                if  let validData = data,
//                    let validImage = UIImage(data: validData) {
//                    DispatchQueue.main.async {
//                        cell.reviewImage.image = validImage
//                        cell.reviewImage.isHidden = false
//                        cell.setNeedsLayout()
//                    }
//                }
//            }
//        } else {
//            cell.reviewImage.isHidden = true
//        }
//        
//        cell.movieTitleLabel.isHidden = !cell.reviewImage.isHidden
        
        return cell
    }


}
