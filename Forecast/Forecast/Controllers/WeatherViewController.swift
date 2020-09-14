//
//  ViewController.swift
//  Forecast
//
//  Created by jboro on 8/29/20.
//  Copyright © 2020 jboro. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var weatherCondition: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var citySearchTextField: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
   
    var weatherManager = WeatherManager()
    let locManager = CLLocationManager()
    var currentCity: String = ""
    var isFromLocation: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        ModifySearchBarUI()
        
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.distanceFilter = 200

        locManager.requestWhenInUseAuthorization()
        locManager.requestLocation()
        
        citySearchTextField.delegate = self
        weatherManager.delegate = self
    }
    
    
    @IBAction func GetCurrentLocationTapped(_ sender: UIButton) {
       
        locManager.startUpdatingLocation()
        
    }
    
    //MARK: - Modify Search Bar UI
    private func ModifySearchBarUI() {
        let placeholderColor = UIColor(red: 0.79, green: 0.58, blue: 0.62, alpha: 0.5)
        let placeholder = citySearchTextField.placeholder ?? ""
        citySearchTextField.attributedPlaceholder = NSAttributedString(string: placeholder,
                attributes: [NSAttributedString
                        .Key.foregroundColor: placeholderColor])


        citySearchTextField.leftView = UIView(frame: CGRect(x: 20,
                y: 0,
                width: 15,
                height: citySearchTextField.frame.height))
        citySearchTextField.leftViewMode = .always
        citySearchTextField.layer.cornerRadius = 25
        citySearchTextField.layer.borderWidth = 2.0
        citySearchTextField.layer.borderColor = UIColor.lightGray.cgColor
    }

}

//MARK: - UITextFieldDelegate Section

extension WeatherViewController : UITextFieldDelegate {

    @IBAction func searchTapped(_ sender: UIButton) {
        citySearchTextField.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        citySearchTextField.endEditing(true)
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {

        if let city = textField.text{
            weatherManager.getWeather(cityName: city)
            isFromLocation = false
        }
        citySearchTextField.text = ""
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Please enter name of city"
            return false
        }
    }
}

//MARK: - WeatherManagerDelegate extension
extension WeatherViewController : WeatherManagerDelegate{
    func updateWeather(_ weatherManager:WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.tempLabel.text = weather.temperatureInCelsius
            self.weatherCondition.image = UIImage(systemName: weather.conditionName)
            if self.isFromLocation{
                self.cityLabel.text = self.currentCity
            }else{
                 self.cityLabel.text = weather.cityName
            }
           
        }

    }

    func failedWithError(error: Error) {
        DispatchQueue.main.async {
            print(error)

            let alert = UIAlertController(title: "Error", message: String("Something went wrong: Please search for a proper city or check your internet connection"), preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

            self.present(alert, animated: true)
        }

    }
}

//MARK: - LocationDelegate
extension WeatherViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location failed: Error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
              locManager.stopUpdatingLocation()
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            weatherManager.getWeather(latitude: latitude, longitude: longitude)
            print("lat: \(latitude), long: \(longitude)")
        }
            let locationVal: CLLocationCoordinate2D = (manager.location!.coordinate)
                   self.weatherManager.getWeather(latitude: locationVal.latitude, longitude: locationVal.longitude)
                          let geoCoder = CLGeocoder()
                          let location = CLLocation(latitude: locationVal.latitude, longitude: locationVal.longitude)
        
                   geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
                       placemarks?.forEach({ (placemark) in
                           if let city = placemark.locality{
                               print(city)
                            self.isFromLocation = true
                            self.currentCity = city

                           }
                       })
                   }
            
    }
    
    
}

