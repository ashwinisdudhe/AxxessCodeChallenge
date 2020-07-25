//
//  File.swift
//  TestDemo
//
//  Created by Ashwini.Dudhe on 22/07/20.
//  Copyright © 2020 Ashwini.Dudhe. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import RealmSwift


class DataManager: NSObject {
    
    class func requestGETURL(_ strURL: String, success:@escaping ([DataModel]) -> Void, failure:@escaping (Error) -> Void) {
        Alamofire.request(strURL).responseJSON { (responseObject) in
            print(responseObject)
            let json = responseObject.data
            do{
                var dataArray = [DataModel]()
                //created the json decoder
                let decoder = JSONDecoder()
                
                //using the array to put values
                dataArray = try decoder.decode([DataModel].self, from: json!)
                
                // Save data in db using realm
                let realm = try Realm()
                print(realm.configuration.fileURL?.absoluteString ?? "")
                for data in dataArray {
                    try realm.write {
                        realm.add(data, update: .modified)
                    }
                }
                success(dataArray)
                
            }catch let err{
                print(err)
                failure(err)
            }
            
        }
    }
    
}

