//
//  ContentView.swift
//  CW2
//
//  Created by Lind Zariqi on 12/05/2022.
//

import SwiftUI
import CoreLocation


struct ContentView: View {
    @State var weatherForView:Weather?
    @State private var location: String = ""
    @State var forecast: Forecast? = nil
    let dateFormatter = DateFormatter()
    init() {
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss" // Date Formatter, source: https://stackoverflow.com/questions/35700281/date-format-in-swift
    }
    var body: some View {
        TabView {
            NavigationView {
                VStack(alignment: .center) {
                    // Weather View
                    Text("Temperature")
                        .foregroundColor(Color.gray)
                    HStack(alignment: .center) {
                        Image("temp")
                            .resizable()
                            .frame(width: 40.0, height: 40.0)
                        Text(weatherForView?.main.temp.description ?? "0.0")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("°C")
                            .font(.title2)
                        Text("").onAppear(perform: getWeather) // automatically shows the data when the app is loaded
                    }
                    Text("Humidity")
                        .foregroundColor(Color.gray)
                        .padding(.top)
                    HStack(alignment: .center) {
                        Image("humidity")
                            .resizable()
                            .frame(width: 40.0, height: 40.0)
                        Text(weatherForView?.main.humidity.description ?? "0.0")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("%")
                            .font(.title2)
                    }
                }
                .padding(.horizontal)
                .navigationTitle("Weather")
            }
            .tabItem {
                Image(systemName: "sun.max.fill")
                Text("Weather")
            }
            
            NavigationView {
                VStack(alignment: .center) {
                    // Detailed View
                    Text("Temperature")
                        .foregroundColor(Color.gray)
                    HStack(alignment: .center) {
                        Image("temp")
                            .resizable()
                            .frame(width: 40.0, height: 40.0)
                        Text(weatherForView?.main.temp.description ?? "0.0")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("°C")
                            .font(.title2)
                        Text("").onAppear(perform: getWeather) // automatically shows the weather when the app is loaded
                    }
                    Text("Humidity")
                        .foregroundColor(Color.gray)
                        .padding(.top)
                    HStack(alignment: .center) {
                        Image("humidity")
                            .resizable()
                            .frame(width: 40.0, height: 40.0)
                        Text(weatherForView?.main.humidity.description ?? "0.0")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("%")
                            .font(.title2)
                    }
                    Text("Pressure")
                        .foregroundColor(Color.gray)
                        .padding(.top)
                    HStack(alignment: .center) {
                        Image("pressure")
                            .resizable()
                            .frame(width: 40.0, height: 40.0)
                        Text(weatherForView?.main.pressure.description ?? "0.0")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Pa")
                            .font(.title2)
                    }
                    Text("Wind Speed")
                        .foregroundColor(Color.gray)
                        .padding(.top)
                    HStack(alignment: .center) {
                        Image("windSpeed")
                            .resizable()
                            .frame(width: 40.0, height: 40.0)
                        Text(weatherForView?.wind.speed.description ?? "0.0")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("mph")
                            .font(.title2)
                    }
                }
                .padding(.horizontal)
                .navigationTitle("Detailed Weather")
            }
            .tabItem {
                Image(systemName: "list.bullet")
                Text("Detailed")
            }
            VStack {
                // Forecast View
                NavigationView {
                    VStack {
                        HStack {
                            TextField("Enter Location", text: $location)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button {
                                getForecast(for: location)
                            } label: {
                                Image(systemName: "magnifyingglass")
                                    .font(.title)
                            }
                        }
                        if let forecast = forecast {
                            List(forecast.daily, id: \.dt) { day in
                                VStack(alignment: .leading) {
                                    Text(dateFormatter.string(from: day.dt))
                                        .fontWeight(.bold)
                                    HStack(alignment: .center) {
                                        Image(systemName: "cloud")
                                            .font(.title)
                                            .frame(width: 50, height: 50)
                                        VStack(alignment: .leading) {
                                            Text(day.weather[0].description.capitalized)// makes the starting letter of each word capitalized
                                                .fontWeight(.bold)
                                            HStack {
                                                Text("Min: \(day.temp.min, specifier: "%.0f")°C")
                                                Text("Max: \(day.temp.max, specifier: "%.0f")°C")
                                            }
                                        }
                                    }
                                }
                            }
                            .listStyle(PlainListStyle())
                        } else {
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    .navigationTitle("Forecast")
                }
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Forecast")
            }
        }
    }
    
    // function for basic weather view and detailed weather view
    func getWeather() {
        let url = setLocationStringForWeather(location: location)
        getCurrentWeather(url: url, completion: {_ in weatherForView = weather})
    }
    
    // function for weather forecast view
    func getForecast(for location: String) {
        let apiService = APIService.shared
        CLGeocoder().geocodeAddressString(location) { (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let lat = placemarks?.first?.location?.coordinate.latitude,
               let lon = placemarks?.first?.location?.coordinate.longitude {
                apiService.getJSON(urlString: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=current,minutely,hourly,alerts&appid=816f7b823ca56a9b8fb348a7e7a03365&units=metric",
                                   dateDecodingStrategy: .secondsSince1970) { (result: Result<Forecast,APIService.APIError>) in
                    switch result {
                    case .success(let forecast):
                        self.forecast = forecast
                    case .failure(let apiError):
                        switch apiError {
                        case .error(let errorString):
                            print(errorString)
                        }
                    }
                }
            }
        }
        
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
