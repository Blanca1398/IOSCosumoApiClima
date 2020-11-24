//
//  ViewController.swift
//  ApiClima
//
//  Created by Blanca Cordova on 23/11/20.
//  Copyright © 2020 Blanca Cordova. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    
    
    var climaManager = ClimaManager()
    var locationManager = CLLocationManager()

    @IBOutlet weak var buscarTextField: UITextField!
    @IBOutlet weak var ciudadLabel: UILabel!
    @IBOutlet weak var temperaturaLabel: UILabel!
    @IBOutlet weak var climaImg: UIImageView!
    
    @IBOutlet weak var climaFondoImg: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        buscarTextField.delegate = self
        climaManager.delegado = self
        //Primero se solicita el permiso
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }

    @IBAction func BuscarButton(_ sender: UIButton) {
        ciudadLabel.text = buscarTextField.text
        climaManager.fetchClima(nombreCiudad: buscarTextField.text!)
    }
    
    @IBAction func getLocalizacion(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

extension ViewController : UITextFieldDelegate {
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
    
}
extension ViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Ubicacion obtenido")
        if let ubicacion = locations.last {
            let lat = ubicacion.coordinate.latitude
            let lon = ubicacion.coordinate.longitude
            print("lat\(lat) lon\(lon)")
            climaManager.fetchClima(lat: lat, lon: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension ViewController : ClimaManagerDelegate {
    func huboError(cualError: Error) {
        print(cualError.localizedDescription)
        DispatchQueue.main.async {
            self.ciudadLabel.text = ""
            self.temperaturaLabel.text = ""
            self.descriptionLabel.text = cualError.localizedDescription
            self.climaFondoImg.image = UIImage(named: "city7.jpg")
            self.climaImg.image = UIImage(systemName:"cloud.fill")
        }
        
    }
    
    func actualizarClima(clima: ClimaModelo) {
        print(clima.temperaturaCelcius)
        print(clima.condicionID)
        print(clima.descriptionClima)
        print(clima.obtenerCondicionClima)
        
        DispatchQueue.main.async {
            self.ciudadLabel.text = String(clima.nombreCiudad)
            self.temperaturaLabel.text = String(clima.temperaturaCelcius)
            self.descriptionLabel.text = clima.descriptionClima
            self.climaFondoImg.image = UIImage(named: clima.obtenerCondicionClima)
            self.climaImg.image = UIImage(systemName:clima.obtenerCondicionClimaIcon)
        }
        
        
    }
}
