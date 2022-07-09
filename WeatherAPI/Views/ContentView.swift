//
//  ContentView.swift
//  WeatherAPI
//
//  Created by Morgane Julian on 08/07/2022.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var contentViewModel: ContentViewModel
    
    var body: some View {
        ZStack {
            Image(self.contentViewModel.weatherImageWithIcon(icon: self.contentViewModel.code).rawValue)
                .resizable()
            VStack {
                //MARK: - City, temperature and text
                VStack(alignment: .center) {
                    Text(self.contentViewModel.weather.city)
                        .padding(5)
                        .font(.largeTitle)
                        .dynamicTypeSize(.large)
                    
                    Text("\(Int(self.contentViewModel.weather.temperature))°")
                        .font(.largeTitle)
                        .bold()
                    
                    Text(self.contentViewModel.weather.text.rawValue)
                        .foregroundColor(.black)
                        .frame(width: 100, height: 50, alignment: .center)
                        .background(Capsule().fill(Color.gray).shadow(radius: 10).opacity(0.5))
                }
                
                //MARK: - Humidity, Pression and wind
                HStack {
                    HStack {
                        Image(systemName: "humidity")
                        Text("\(self.contentViewModel.weather.humidity)%")
                    }
                    .padding()
                    HStack {
                        Image(systemName: "thermometer")
                        Text("\(Int(self.contentViewModel.weather.pression))%")
                    }
                    .padding()
                    
                    HStack {
                        Image(systemName: "wind")
                        Text("\(Int(self.contentViewModel.weather.visKM))Km/h")
                    }
                    .padding()
                }.padding()
                
                //MARK: - Forecast Days
                VStack() {
                    ForEach(contentViewModel.weatherDays, id: \.id) { day in
                        HStack {
                            Spacer()
                            Text(day.date)
                            Spacer()
                            Image(String(day.day.codeCondition))
                                .resizable()
                                .frame(width: 30, height: 30, alignment: .center)
                            Spacer()
                            Text("\(Int(day.day.maxtempC))")
                                .bold()
                            Spacer()
                            Text("\(Int(day.day.mintempC))")
                                .bold()
                            Spacer()
                        }
                        Divider()
                    }
                }
                Text("Powered by WeatherApi.com")
                    .padding()
                    .font(.footnote)
            }
        }.onAppear {
            Task {
                self.contentViewModel.getLocationAndCallApiWeather()
                    }
                    
                }
               
            }
        }

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE (3rd generation)", "iPhone 13 Pro Max"], id: \.self) {
            ContentView(contentViewModel: ContentViewModel())
                .previewDevice(.init(rawValue: $0))
                .previewDisplayName($0)
        }
    }
}
#endif
