//
//  ViewController.swift
//  Forecast
//
//  Created by jboro on 8/29/20.
//  Copyright © 2020 jboro. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var weatherCondition: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var citySearchTextField: UITextField!

    var weatherManager = WeatherManager()

    override func viewDidLoad() {
        super.viewDidLoad()

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
        citySearchTextField.layer.cornerRadius = 15.0
        citySearchTextField.layer.borderWidth = 2.0
        citySearchTextField.layer.borderColor = UIColor.lightGray.cgColor

        citySearchTextField.delegate = self

    }

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

