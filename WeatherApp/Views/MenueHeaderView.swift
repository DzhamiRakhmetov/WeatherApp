//
//  MenueHeaderView.swift
//  WeatherApp
//
//  Created by Dzhami on 03.10.2023.
//

import SwiftUI

struct MenueHeaderView: View {
    
    @ObservedObject var cityVM: CityViewModel
    @State private var searchTerm = "Новосибирск"
    
    var body: some View {
        HStack {
            TextField("", text: $searchTerm)
                .padding(.leading, 20)
            Button {
                cityVM.city = searchTerm
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.blue)
                    
                    Image(systemName: "location.fill")
                }
            }
            .frame(width: 50, height: 50)
        }
        .foregroundColor(.white)
        .padding()
        .background(ZStack(alignment: .leading) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white)
                .padding(.leading, 10)
            
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.blue.opacity(0.3))
        })
    }
}

struct MenueHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
