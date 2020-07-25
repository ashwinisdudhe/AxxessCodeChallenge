//
//  CustomCell.swift
//  TestDemo
//
//  Created by Ashwini.Dudhe on 23/07/20.
//  Copyright © 2020 Ashwini.Dudhe. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class CustomCell: UITableViewCell {
    
    // Declaration of UI element
     var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
     }()
 
    var picture: UIImageView = {
        let picture = UIImageView()
        
        return picture
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    // USer defined functions intiial UI setup with constraints
    func setupView() {
 
        contentView.addSubview(label)

        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(20)

        }
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping


        contentView.addSubview(picture)
        picture.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(label.snp.bottom).offset(20)
        }

        
    }
    
}
