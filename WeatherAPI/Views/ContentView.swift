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
                Image("background")
                .resizable()
            VStack {
                
                //MARK: - City, temperature and text
                VStack(alignment: .center) {
                    Text("Tokyo")
                        .padding()
                        .font(.largeTitle)
                        .dynamicTypeSize(.large)
                    
                    Text("23°")
                        .font(.largeTitle)
                        .bold()
                    
                    Text("Nuageux")
                        .foregroundColor(.black)
                        .frame(width: 100, height: 50, alignment: .center)
                        .background(Capsule().fill(Color.gray).shadow(radius: 10).opacity(0.5))
                }
                .padding()
                
                //MARK: - Humidity, Pression and wind
                HStack {
                    HStack {
                        Image(systemName: "humidity")
                        Text("13%")
                    }
                    .padding()
                    HStack {
                        Image(systemName: "thermometer")
                        Text("13%")
                    }
                    .padding()
                    
                    HStack {
                        Image(systemName: "wind")
                        Text("13%")
                    }
                    .padding()
                }
                .padding()
                
                //MARK: - Forecast Days
                VStack {
                    ForEach(contentViewModel.weatherDays, id: \.id) { day in
                        HStack {
                            Spacer()
                            Text("Monday")
                            Spacer()
                            Image("sun")
                                .resizable()
                                .frame(width: 30, height: 30, alignment: .center)
                            Spacer()
                            Text("25°")
                                .bold()
                            Spacer()
                            Text("8°")
                                .bold()
                            Spacer()
                        }
                        Divider()
                    }
                }
            }
        }.onAppear {
            Task {
                contentViewModel.getWeather(city: "London")
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
