//
//  DetailTableViewCell.swift
//  Weather
//
//  Created by Jacob Roscoe on 2020/7/1.
//  Copyright © 2020 ColorTV. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    // MARK: - UI Components
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblPressure: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblWindSpeed: UILabel!
    @IBOutlet weak var imvWindDirection: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    public func configure(with weather: Weather) {
        
        lblTemp.text = "\(weather.temperature) ℃"
        lblPressure.text = "\(weather.pressure) mbar"
        lblHumidity.text = "\(weather.humidity) %"
        lblWindSpeed.text = "\(weather.windSpeed) m/s"
        let angle = CGFloat(weather.windDeg) / 180.0 * CGFloat.pi
        imvWindDirection.transform = CGAffineTransform(rotationAngle: angle)
    }
}
