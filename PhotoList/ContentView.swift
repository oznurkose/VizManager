//
//  ContentView.swift
//  PhotoList
//
//  Created by Öznur Köse on 7.04.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var images = ImageModel()
    var body: some View {
        TabView {
            PhotoListView()
                .environmentObject(images)
                .tabItem {
                    Label("Photos", systemImage: "photo.on.rectangle")
                }
            
            SettingsView()
                .environmentObject(images)
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }

            
        }
     
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        ContentView()
            .environmentObject(ImageModel.ImagesSample)
    }
}