//
//  ViewController.swift
//  ApiClima
//
//  Created by Blanca Cordova on 23/11/20.
//  Copyright © 2020 Blanca Cordova. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, ClimaManagerDelegate {
    func actualizarClima(clima: ClimaModelo) {
        print(clima.temperaturaCelcius)
        print(clima.condicionID)
        print(clima.descriptionClima)
    }
    
    
    var climaManager = ClimaManager()

    @IBOutlet weak var buscarTextField: UITextField!
    @IBOutlet weak var ciudadLabel: UILabel!
    @IBOutlet weak var temperaturaLabel: UILabel!
    @IBOutlet weak var climaImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buscarTextField.delegate = self
        climaManager.delegado = self
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        buscarTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(buscarTextField.text!)
        ciudadLabel.text = buscarTextField.text
        climaManager.fetchClima(nombreCiudad: buscarTextField.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if buscarTextField.text != "" {
            return true
        } else {
            buscarTextField.placeholder = "Escribe una ciudad"
            return false
        }
    }
    
    @IBAction func BuscarButton(_ sender: UIButton) {
        ciudadLabel.text = buscarTextField.text
        climaManager.fetchClima(nombreCiudad: buscarTextField.text!)
    }
    


}

