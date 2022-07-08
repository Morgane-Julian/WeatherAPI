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
                
                //MARK: - City, temperature and text
                VStack(alignment: .leading) {
                    Text("San Fransisco")
                        .padding()
                        .font(.largeTitle)
                        .dynamicTypeSize(.large)
                    
                    Text("18°")
                        .font(.largeTitle)
                        .bold()
                    Text("Cloudy")
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
                
                //MARK: - Forecast Carousel
//                ZStack {
//                    ForEach(contentViewModel.items) { item in
//                        ZStack {
//                            RoundedRectangle(cornerRadius: 18)
//                                .fill(.gray)
//                            Text(item.title)
//                                .padding()
//                        }
//                        .frame(width: 200, height: 200)
//
//                        .scaleEffect(1.0 - abs(contentViewModel.distance(item.id)) * 0.2 )
//                        .opacity(1.0 - abs(contentViewModel.distance(item.id)) * 0.3 )
//                        .offset(x: contentViewModel.myXOffset(item.id), y: 0)
//                        .zIndex(1.0 - abs(contentViewModel.distance(item.id)) * 0.1)
//                    }
//                }
//                .gesture(
//                    DragGesture()
//                        .onChanged { value in
//                            contentViewModel.draggingItem = contentViewModel.snappedItem + value.translation.width / 100
//                        }
//                        .onEnded { value in
//                            withAnimation {
//                                contentViewModel.draggingItem = contentViewModel.snappedItem + value.predictedEndTranslation.width / 100
//                                contentViewModel.draggingItem = round(contentViewModel.draggingItem).remainder(dividingBy: Double(contentViewModel.items.count))
//                                contentViewModel.snappedItem = contentViewModel.draggingItem
//                            }
//                        })
            }
        .background(
            Image("")
                .resizable()
        )
        .onAppear {
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
            //                .preferredColorScheme(.dark)
        }
    }
}
#endif
