//
//  ClimaManager.swift
//  ApiClima
//
//  Created by Blanca Cordova on 23/11/20.
//  Copyright © 2020 Blanca Cordova. All rights reserved.
//

import Foundation
struct ClimaManager {
    //let climaURL = "http://api.openweathermap.org/data/2.5/weather?appid=698cb29c0a1e70d1a30a0a9982f6a95a&units=metric&q=Morelia"
    let climaURL = "http://api.openweathermap.org/data/2.5/weather?appid=698cb29c0a1e70d1a30a0a9982f6a95a&units=metric"
    func fetchClima(nombreCiudad: String) {
        let urlString = "\(climaURL)&q=\(nombreCiudad)"
        print(urlString)
    }
    
    func realizarSolicitud(urlString: String) {
        //Crear la URL
        if let url = URL(string: urlString){
            //Crear obj URLSession
            let session = URLSession(configuration: .default)
            //Asignar una tarea a la sesion
            let tarea = session.dataTask(with: url, completionHandler: handle(data:respuesta:error:))
            tarea.resume()
        }
    }
    //Metodo para evitar que la app se congele mientras recibe la informacion de la API
    func handle(data:Data?, respuesta:URLResponse?, error:Error?){
        if error != nil {
            print(error!)
            return
        }
        if let datosSeguros = data {
            let dataString = String(data: datosSeguros, encoding: .utf8)
            print(dataString)
        }
    }
}
