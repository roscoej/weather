//
//  MainTableViewCell.swift
//  Weather
//
//  Created by Jacob Roscoe on 2020/7/1.
//  Copyright © 2020 ColorTV. All rights reserved.
//

import UIKit
import SDWebImage

class MainTableViewCell: UITableViewCell {

    // MARK: - UI Components
    @IBOutlet weak var imvIcon: UIImageView!
    @IBOutlet weak var lblMain: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    public func configure(with weather: Weather) {
        
        imvIcon.sd_setImage(with: URL(string: weather.getIconURL()))
        lblMain.text = weather.main
        lblDescription.text = weather.description
    }
}
