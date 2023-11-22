////
////  ForecastViewModel.swift
////  CW2
////
////  Created by Lind Zariqi on 21/05/2022.
////
//
//import Foundation
//
//struct ForecastViewModel {
//    let forecast: Forecast.Daily
//    var system: Int
//    
//    private static var dateFormatter: DateFormatter {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
//        return dateFormatter
//    }
//    
//    private static var numberFormatter: NumberFormatter {
//        let numberFormatter = NumberFormatter()
//        numberFormatter.maximumFractionDigits = 0
//        return numberFormatter
//    }
//    
//    func convert(_ temp: Double) -> Double {
//        let celsius = temp - 273.5
//        if system == 0 {
//            return celsius
//        } else {
//            return celsius * 9 / 5 + 32
//        }
//    }
//    
//    var day: String {
//        return Self.dateFormatter.string(from: forecast.dt)
//    }
//    
//    var overview: String {
//        forecast.weather[0].description.capitalized
//    }
//    
//    var high: String {
//        return "H: \(Self.numberFormatter.string(for: convert(forecast.temp.max)) ?? "0")°"
//    }
//    
//    var low: String {
//        return "L: \(Self.numberFormatter.string(for: convert(forecast.temp.min)) ?? "0")°"
//    }
//}
