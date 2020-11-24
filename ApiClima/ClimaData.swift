//
//  ClimaData.swift
//  ApiClima
//
//  Created by Blanca Cordova on 23/11/20.
//  Copyright © 2020 Blanca Cordova. All rights reserved.
//

import Foundation

struct ClimaData:Decodable {
    let name: String
    let timezone:Int
    let main:Main
    let coord:Coord
}

struct Main:Decodable {
    let temp:Double
}
struct Coord:Decodable {
    let lon:Double
    let lat:Double
}
