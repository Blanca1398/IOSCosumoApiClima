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
        if buscarTextField.text != "" {
            ciudadLabel.text = buscarTextField.text
            climaManager.fetchClima(nombreCiudad: buscarTextField.text!)
        }
        else {
            //Alerta
            let alerta = UIAlertController(title: "Campo Vacio", message: "Porfavor asegurese de no dejar el campo vacio al buscar", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Entendido", style: .default, handler: nil)
            alerta.addAction(actionOk)
            self.present(alerta, animated: true, completion: nil)
        }
        
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
        if buscarTextField.text != "" {
            ciudadLabel.text = buscarTextField.text
            climaManager.fetchClima(nombreCiudad: buscarTextField.text!)
            return true
        }
        else {
            //Alerta
            let alerta = UIAlertController(title: "Campo Vacio", message: "Porfavor asegurese de no dejar el campo vacio al buscar", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Entendido", style: .default, handler: nil)
            alerta.addAction(actionOk)
            self.present(alerta, animated: true, completion: nil)
            return false
        }
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
            if cualError.localizedDescription == "The data couldn’t be read because it is missing." {
                //Alerta
                let alerta = UIAlertController(title: "Ciudad Desconocida", message: "Verifica que el nombre de la ciudad esta bien escrito e intentalo de nuevo", preferredStyle: .alert)
                let actionOk = UIAlertAction(title: "Entendido", style: .default, handler: nil)
                alerta.addAction(actionOk)
                self.present(alerta, animated: true, completion: nil)
                self.descriptionLabel.text = "Ciudad Desconocida"
            }
            if cualError.localizedDescription == "The Internet connection appears to be offline." {
                //Alerta
                let alerta = UIAlertController(title: "Conexion de Internet", message: "Verifique que tenga internet e intentelo de nuevo", preferredStyle: .alert)
                let actionOk = UIAlertAction(title: "Entendido", style: .default, handler: nil)
                alerta.addAction(actionOk)
                self.present(alerta, animated: true, completion: nil)
                self.descriptionLabel.text = "Verifica Conexion de Internet"
            }
            self.ciudadLabel.text = ""
            self.temperaturaLabel.text = ""
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
