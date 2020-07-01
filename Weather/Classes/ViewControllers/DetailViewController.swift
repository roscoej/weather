//
//  DetailViewController.swift
//  Weather
//
//  Created by Jacob Roscoe on 2020/7/1.
//  Copyright © 2020 ColorTV. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: - UI Components
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    let refreshControl = UIRefreshControl()
    
    // MARK: - Public Variables
    public var lat: Double = 0
    public var lon: Double = 0
    
    // MARK: - Private Variables
    private var weather: Weather? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        loadWeather()
    }
    

    // MARK: - Private Functions
    
    private func setupUI() {
        // refresh control
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.dataSource = self
        indicator.isHidden = true
    }
    
    private func loadWeather() {

        if Utils.isConnectedToInternet {
            
            if !refreshControl.isRefreshing {
                indicator.isHidden = false
                indicator.startAnimating()
            }
            
            APIManager.shared.getWeather(lat: lat, lon: lon) { (weather, err) in
                
                self.refreshControl.endRefreshing()
                self.indicator.stopAnimating()
                self.indicator.isHidden = true
                
                if let weather = weather {
                    weather.saveToUserDefaults()
                    self.weather = weather
                    self.displayWeather()
                } else {
                    
                    let alert = UIAlertController(title: "Sorry", message: err, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else {
            
            if let weather = Weather.loadFromUserDefaults(for: lat, lon: lon) {
                self.weather = weather
                displayWeather()
            } else {
                
                let label = UILabel()
                label.textAlignment =  .center
                label.text = "Internet Disconnected"
                label.font = UIFont.boldSystemFont(ofSize: 25.0)
                tableView.backgroundView = label
            }
        }
    }
    
    private func displayWeather() {
        tableView.reloadData()
    }
    
    @objc private func refresh() {
        tableView.backgroundView = nil
        refreshControl.beginRefreshing()
        loadWeather()
    }
}


// MARK: - UITableViewDataSource

extension DetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (weather == nil) ? 0 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as! MainTableViewCell
            
            cell.configure(with: self.weather!)
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
            
            cell.configure(with: self.weather!)
            
            return cell
        }
    }
}
