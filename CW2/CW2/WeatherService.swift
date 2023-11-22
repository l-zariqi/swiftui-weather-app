//
//  WeatherService.swift
//  CW2
//
//  Created by Lind Zariqi on 17/05/2022.
//

import Foundation
class WeatherService: ObservableObject {
    @Published var temp: Double = 0.0
    @Published var summary: String = ""
    @Published var errorMessage: String = ""
}
