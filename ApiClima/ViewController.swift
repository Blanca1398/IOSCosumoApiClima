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
    
    
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var sensacionLabel: UILabel!
    @IBOutlet weak var vientosLabel: UILabel!
    
    
    @IBOutlet weak var c1Label: UILabel!
    @IBOutlet weak var c2Label: UILabel!
    @IBOutlet weak var c3Label: UILabel!
    @IBOutlet weak var kmLabel: UILabel!
    
    var aqua:UIColor?
    
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
    
    //funcion para convertir color hexa de UIColor
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
         red: CGFloat((rgbValue & 0xFF0000) >> 16)/255.0,
         green: CGFloat((rgbValue & 0x00FF00) >> 8)/255.0,
         blue: CGFloat(rgbValue & 0x0000FF)/255.0,
         alpha: CGFloat(1.0)
        )
    }
    
    //cerrar teclado
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
            self.maxLabel.text = ""
            self.minLabel.text = ""
            self.vientosLabel.text = ""
            self.sensacionLabel.text = ""
        }
        
    }
    
    func actualizarClima(clima: ClimaModelo) {
        print(clima.temperaturaCelcius)
        print(clima.condicionID)
        print(clima.descriptionClima)
        print(clima.obtenerCondicionClima)
        
        DispatchQueue.main.async {
            //Color del icono
            self.climaImg.tintColor = self.UIColorFromRGB(rgbValue: clima.obtenerColorTexto)
            
            //Color del texto
            self.maxLabel.textColor = self.UIColorFromRGB(rgbValue: clima.obtenerColorTexto)
            self.minLabel.textColor = self.UIColorFromRGB(rgbValue: clima.obtenerColorTexto)
            self.vientosLabel.textColor = self.UIColorFromRGB(rgbValue: clima.obtenerColorTexto)
            self.sensacionLabel.textColor = self.UIColorFromRGB(rgbValue: clima.obtenerColorTexto)
            
            self.c1Label.textColor = self.UIColorFromRGB(rgbValue: clima.obtenerColorTexto)
            self.c2Label.textColor = self.UIColorFromRGB(rgbValue: clima.obtenerColorTexto)
            self.c3Label.textColor = self.UIColorFromRGB(rgbValue: clima.obtenerColorTexto)
            self.kmLabel.textColor = self.UIColorFromRGB(rgbValue: clima.obtenerColorTexto)
            
            //Color de la sombra del texto
            self.maxLabel.shadowColor = self.UIColorFromRGB(rgbValue: clima.obtenerSombraTexto)
            self.minLabel.shadowColor = self.UIColorFromRGB(rgbValue: clima.obtenerSombraTexto)
            self.vientosLabel.shadowColor = self.UIColorFromRGB(rgbValue: clima.obtenerSombraTexto)
            self.sensacionLabel.shadowColor = self.UIColorFromRGB(rgbValue: clima.obtenerSombraTexto)
            
            self.c1Label.shadowColor = self.UIColorFromRGB(rgbValue: clima.obtenerSombraTexto)
            self.c2Label.shadowColor = self.UIColorFromRGB(rgbValue: clima.obtenerSombraTexto)
            self.c3Label.shadowColor = self.UIColorFromRGB(rgbValue: clima.obtenerSombraTexto)
            self.kmLabel.shadowColor = self.UIColorFromRGB(rgbValue: clima.obtenerSombraTexto)

            self.ciudadLabel.text = String(clima.nombreCiudad)
            self.temperaturaLabel.text = String(clima.temperaturaCelcius)
            self.descriptionLabel.text = clima.descriptionClima
            self.climaFondoImg.image = UIImage(named: clima.obtenerCondicionClima)
            self.climaImg.image = UIImage(systemName:clima.obtenerCondicionClimaIcon)
           
            self.maxLabel.text = String(clima.temperaturaMaxima)
            self.minLabel.text = String(clima.temperaturaMinima)
            self.vientosLabel.text = String(clima.vientos)
            self.sensacionLabel.text = String(clima.sensasionTermica)
            
            
        }
        
        
    }
}
