//
//  WeatherModel.swift
//  CW2
//
//  Created by Lind Zariqi on 13/05/2022.
//

import UIKit


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weather = try? newJSONDecoder().decode(Weather.self, from: jsonData)

import Foundation

// MARK: - Weather
struct Weather: Codable {
    let coord: Coord
    let weather: [WeatherElement]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - WeatherElement
struct WeatherElement: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
}


var weather:Weather?

//gets the JSON data
func getCurrentWeather(url:String, completion: @escaping (Weather)->()) {
    let session = URLSession(configuration: .default)
    session.dataTask(with:URL(string: url)!) {(data, _, err) in
        if err != nil {
            print(err!.localizedDescription)
            return
        }
        DispatchQueue.main.async {
            do {
                weather = try JSONDecoder().decode(Weather.self, from: data!)
                print("Temp. feels like \(String(describing: weather?.main.feelsLike))")
                completion(weather!)
            }
            catch{
                print(error)
            }
        }
    }.resume()
}

let apiKey:String = "816f7b823ca56a9b8fb348a7e7a03365"


func setLocationStringForWeather(location: String)->String {
    return "https://api.openweathermap.org/data/2.5/weather?q=\(location)&appid=\(apiKey)&units=metric"
}

//let url = setLocationURLString(location: "London")
//
//getCurrentWeather(url: url, completion: {_ in print("completed")})
