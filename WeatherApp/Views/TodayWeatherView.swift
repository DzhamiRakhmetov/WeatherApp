//
//  TodayWeatherView.swift
//  WeatherApp
//
//  Created by Dzhami on 04.10.2023.
//

import SwiftUI

struct TodayWeatherView: View {
    
    @ObservedObject var cityVM: CityViewModel
    
    var body: some View {
        VStack (spacing: 10) {
            Text("Сегодня")
                .font(.largeTitle)
                .bold()
            
            HStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("\(cityVM.temperature)℃")
                        .font(.system(size: 42))
                }
            }
            
            HStack {
                Spacer()
                widgetView(image: "wind", color: .green, title: "\(cityVM.windSpeed) м/сек")
                Spacer()
                widgetView(image: "drop.fill", color: .blue, title: "\(cityVM.humidity)")
                Spacer()
                widgetView(image: "umbrella.fill", color: .red, title: "\(cityVM.rainChances)")
                Spacer()
            }
        }
        .padding()
        .foregroundColor(.white)
        .background(RoundedRectangle(cornerRadius: 30).fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.blue]), startPoint: .top, endPoint: .bottom)).opacity(0.3))
        .shadow(color: Color.white.opacity(0.1), radius: 2, x: -2, y: -2)
        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 2, y: 2)
    }
    
    private func widgetView(image: String, color: Color, title: String) -> some View {
        VStack {
            Image(systemName: image)
                .padding()
                .font(.title)
                .foregroundColor(color)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
            Text(title)
        }
    }
}

struct TodayWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
