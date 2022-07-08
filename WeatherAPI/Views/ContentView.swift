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
        VStack {
            Text(contentViewModel.weather.text)
                .padding()
                .font(.caption)
                .dynamicTypeSize(.large)
            Button("GO") {
                contentViewModel.getWeather(city: "London")
            }.padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 11 Pro Max", "iPhone SE (3rd generation)"], id: \.self) {
            ContentView(contentViewModel: ContentViewModel())
                .previewDevice(.init(rawValue: $0))
                .previewDisplayName($0)
            //                .preferredColorScheme(.dark)
        }
    }
}
