//
//  CellModel.swift
//  Weather Forecast
//
//  Created by stavigor on 27.06.2021.
//

import Foundation
import UIKit


class CellModel: UITableViewCell {
    
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
               
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
         
    }
   
}
