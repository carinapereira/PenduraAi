//
//  ListClienteSaleTableViewCell.swift
//  ShoppingNotebook
//
//  Created by carina  dos santos pereira on 01/12/16.
//  Copyright © 2016 carina  dos santos pereira. All rights reserved.
//

import UIKit

class ListClienteSaleTableViewCell: UITableViewCell {

    @IBOutlet weak var lbTotal: UILabel!
    @IBOutlet weak var lbFone: UILabel!
    @IBOutlet weak var lbNome: UILabel!
    @IBOutlet weak var imgView: UIImageView! {
        didSet{
            imgView.layer.cornerRadius = imgView.frame.size.width / 2
            imgView.clipsToBounds = true
        }
        
    }
   
}
