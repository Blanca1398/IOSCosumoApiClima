//
//  ClimaModelo.swift
//  ApiClima
//
//  Created by Blanca Cordova on 23/11/20.
//  Copyright © 2020 Blanca Cordova. All rights reserved.
//

import Foundation
struct ClimaModelo {
    let condicionID:Int
    let nombreCiudad:String
    let temperaturaCelcius:Double
    let descriptionClima:String
    let temperaturaMaxima:Double
    let temperaturaMinima:Double
    let sensasionTermica:Double
    let vientos:Double
    
    var obtenerCondicionClima:String {
        switch condicionID {
        case 200...232:
            return "tormenta.jpg"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "llovizna.jpg"
        case 600...622:
            return "nevando.jpg"
        case 800:
            return "despejado.jpg"
        case 800...804:
            return "nuboso.jpg"
        default:
            return "city7.jpg"
        }
    }
    var obtenerCondicionClimaIcon:String {
        switch condicionID {
        case 200...232:
            return "cloud.bolt.rain.fill"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.drizzle.fill"
        case 600...622:
            return "snow"
        case 800:
            return "sun.min.fill"
        case 800...804:
            return "cloud.fill"
        default:
            return "cloud.fill"
        }
    }
    var obtenerColorTexto:UInt {
        switch condicionID {
        case 200...232:
            return 0xffffff
        case 300...321:
            return 0xffffff
        case 500...531:
            return 0xffffff
        case 600...622:
            return 0x1BC3B9
        case 800:
            return 0xffffff
        case 800...804:
            return 0xffffff
        default:
            return 0xffffff
        }
    }
    
     var obtenerSombraTexto:UInt {
           switch condicionID {
           case 200...232:
               return 0x000000
           case 300...321:
               return 0x000000
           case 500...531:
               return 0x000000
           case 600...622:
               return 0xffffff
           case 800:
               return 0x000000
           case 800...804:
               return 0x000000
           default:
               return 0x000000
           }
       }
}
