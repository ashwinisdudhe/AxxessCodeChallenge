//
//  ViewController.swift
//  TestDemo
//
//  Created by Ashwini.Dudhe on 22/07/20.
//  Copyright © 2020 Ashwini.Dudhe. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit
import RealmSwift
import SVProgressHUD


class TableViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {
    
    var window: UIWindow?
    var dataArray = [DataModel]()
    let tableview: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    // MARK:- UIView lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupTableView()
        
        if Reachability.isConnectedToNetwork() {
            DispatchQueue.main.async {
                SVProgressHUD.show()
            }
            self.getJsonDataFromServer()
        }
        else {
            let dataArrayFromDB = try! Realm().objects(DataModel.self)
            for data in dataArrayFromDB {
                self.dataArray.append(data)
            }
            print("Data from db - \(dataArray)")
            if dataArray.count > 0 {
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
            }
        }
        
        
    }
    
    // MARK:- User defined function
    // Add table with constraints
    func setupTableView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.estimatedRowHeight = 100
        tableview.rowHeight = UITableView.automaticDimension
        
       
        tableview.register(CustomCell.self, forCellReuseIdentifier: "cellId")
        view.addSubview(tableview)
        
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableview.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableview.leftAnchor.constraint(equalTo: self.view.leftAnchor)
            ])
    }

    
    // Get json data from url
    func getJsonDataFromServer() {
        
        let jsonURL = "https://raw.githubusercontent.com/AxxessTech/Mobile-Projects/master/challenge.json";
        
        DataManager.requestGETURL(jsonURL, success: {(jsonArray) in
          
           self.dataArray = jsonArray
            if self.dataArray.count > 0 {
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.tableview.reloadData()
                }
            }
            print("viewcontroller - \(self.dataArray)")
            
        }) { (error) in
            print("Error in getting json data - \(error)") 
        }
        
    }
    
    //MARK:- Tableview delagte methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = tableview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CustomCell
        cell.backgroundColor = UIColor.white
        if self.dataArray[indexPath.row].type == "image" {
            cell.label.text = self.dataArray[indexPath.row].date
            
            Alamofire.request(self.dataArray[indexPath.row].data ?? "").responseData { (response) in
                if response.error == nil {
                    if let data = response.data {
                        print("Image data - \(data)")
                        DispatchQueue.main.async {
                            cell.picture.image = UIImage(data: data)
                           
                        }
                    }
                }
                
            }
        }
        else {
           
            if let data = self.dataArray[indexPath.row].data {
                cell.label.text = "\(self.dataArray[indexPath.row].date ?? "No date") \n \(data)"
            }
            else {
                cell.label.text = "Data is null"
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = DetailViewController()
        vc.dataObject = self.dataArray[indexPath.row]
        let navigationController = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
        navigationController.pushViewController(vc, animated: true)
        
    }


}

