//
//  ClimaManager.swift
//  ApiClima
//
//  Created by Blanca Cordova on 23/11/20.
//  Copyright © 2020 Blanca Cordova. All rights reserved.
//

import Foundation

//Quien adopte ese protocolo tendra que implementar el metodo actualizar clima
protocol ClimaManagerDelegate {
    func actualizarClima(clima: ClimaModelo)
    func huboError(cualError: Error)
}

struct ClimaManager {
    var delegado: ClimaManagerDelegate?
    let climaURL = "https://api.openweathermap.org/data/2.5/weather?appid=698cb29c0a1e70d1a30a0a9982f6a95a&units=metric&lang=es"
    
    func fetchClima(nombreCiudad: String) {
        let urlString = "\(climaURL)&q=\(nombreCiudad)"
        print(urlString)
        realizarSolicitud(urlString: urlString)
    }
    func fetchClima(lat:Double, lon:Double) {
        let urlString = "\(climaURL)&lat=\(lat)&lon=\(lon)"
        realizarSolicitud(urlString: urlString)
    }
    
    func realizarSolicitud(urlString: String) {
        //Crear la URL
        if let url = URL(string: urlString){
            //Crear obj URLSession
            let session = URLSession(configuration: .default)
            //Asignar una tarea a la sesion
            //let tarea = session.dataTask(with: url, completionHandler: handle(data:respuesta:error:))
            let tarea = session.dataTask(with: url) { (data, respuesta, error) in
                if error != nil {
                    print(error!)
                    self.delegado?.huboError(cualError: error!)
                    return
                }
                if let datosSeguros = data {
                    if let clima = self.parseJSON(climaData: datosSeguros) {
                        self.delegado?.actualizarClima(clima: clima)
                    }
                }
            }
            //Empezar la tarea
            tarea.resume()
        }
    }

    func parseJSON(climaData: Data) -> ClimaModelo? {
        let decoder = JSONDecoder()
        do {
            let dataDecodificada = try decoder.decode(ClimaData.self, from: climaData)
            let id = dataDecodificada.weather[0].id
            let nombre = dataDecodificada.name
            let temperatura = dataDecodificada.main.temp
            let descripcion = dataDecodificada.weather[0].description
            let vientos = dataDecodificada.wind.speed
            let maxima = dataDecodificada.main.temp_max
            let minima = dataDecodificada.main.temp_min
            let sensacion = dataDecodificada.main.feels_like
            
            //Crear obj personalizado
            let ObjClima = ClimaModelo(condicionID: id, nombreCiudad: nombre, temperaturaCelcius: temperatura, descriptionClima: descripcion,temperaturaMaxima: maxima, temperaturaMinima: minima, sensasionTermica: sensacion, vientos: vientos)
            
            return ObjClima
        } catch {
            print(error)
            delegado?.huboError(cualError: error)
            return nil
        }
    }
}
