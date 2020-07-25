//
//  TestViewController.swift
//  TestDemo
//
//  Created by Ashwini.Dudhe on 25/07/20.
//  Copyright © 2020 Ashwini.Dudhe. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
import Alamofire

class DetailViewController: UIViewController {

    var dataObject : DataModel? = nil
    
    
    
    
    
    
    //MARK:- View lifecycle method
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUIandConstraint()
       
    }

    //MARK:- USer defined functions
    func setUIandConstraint() {
        // UISetup and adding constraints
        view.backgroundColor = UIColor.white
        
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(scrollView)
            make.left.right.equalTo(view) // => IMPORTANT: this makes the width of the contentview static (= size of the screen), while the contentview will stretch vertically
        }
        
        let label = UILabel()
        contentView.addSubview(label)
        label.numberOfLines = 0
        if dataObject?.type == "text" {
            if let data = dataObject?.data {
                label.text = "\(dataObject?.date ?? "No date") \n \(data)"
            }
            else {
                label.text = "Data is null"
            }
        }
        else {
            label.text = dataObject?.date
        }
        
        label.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView).inset(20) // left/right padding 20pt
            make.top.equalTo(contentView).offset(20) // attached to the top of the contentview with padding 20pt
        }
        
        
        let picture = UIImageView()
        contentView.addSubview(picture)
        picture.image = #imageLiteral(resourceName: "placeholder@2x.png")
        if dataObject?.type == "image" {
            if Reachability.isConnectedToNetwork() {
                if (dataObject?.data?.isValidURL)! {
                    SVProgressHUD.show()
                    Alamofire.request(dataObject?.data ?? "").responseData { (response) in
                        if response.error == nil {
                            if let data = response.data {
                                DispatchQueue.main.async {
                                    picture.image = UIImage(data: data)
                                    SVProgressHUD.dismiss()
                                }
                            }
                        }
                    }
                }
                else {
                    self.showAlert(title: "Alert", message: "URL is not valid")
                }
                
            }
            else {
                self.showAlert(title: "Alert", message: "Please check your internet connection")
            }
            
            picture.snp.makeConstraints { (make) in
                make.left.right.equalTo(contentView).inset(20) // left/right padding 20pt
                make.top.equalTo(label.snp.bottom).offset(10) // below label with margin 20pt
                make.bottom.equalTo(view).offset(-20) // attached to the bottom of the contentview with padding 20pt
            }
        }
        
    }
    
    // Show alert with user information
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    

}
