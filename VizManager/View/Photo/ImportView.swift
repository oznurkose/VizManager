//
//  ImportView.swift
//  PhotoList
//
//  Created by Öznur Köse on 7.04.2023.
//
import MapKit
import SwiftUI

struct ImportView: View {
    @State var selectedImages = [UIImage]()
    @State private var isImagePicker = false
    
    @State private var imageName = ""
    @State private var successAlert = false
    @State private var errorAlert = false
    @EnvironmentObject var images: ImageModelView
    @EnvironmentObject var locationFetcher: LocationFetcher
    
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.785834, longitude: -122.406417), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
    @State var annotations = [ImageData.MapAnnotations]()
    
    @State private var addLocation = false
    @State private var addPhoto = false
    var columns = [GridItem(.adaptive(minimum: 200))]
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geo in
                    Group {
                        if selectedImages.isEmpty {
                            ImagePlaceholderView()
                                .frame(width: geo.size.width, height: geo.size.height)
                                .onTapGesture {
                                    isImagePicker = true
                                }
                        }
                        
                        else {
                            
                            ScrollView(.horizontal) {
                                LazyHStack {
                                    ForEach(selectedImages, id: \.self) { img in
                                        ZStack(alignment: .topTrailing) {
                                            Image(uiImage: img)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: (geo.size.width * 0.90))
                                                .shadow(color: Color.primary.opacity(0.3), radius: 1)
                                            
                                            
                                            DeleteButton()
                                                .onTapGesture {
                                                    let ix = selectedImages.firstIndex(of: img)
                                                    selectedImages.remove(at: ix!)
                                                }
                                        }
                                        .padding()
                                        //.frame(width: geo.size.width, height: geo.size.height / 3)
                                    }
                                }
                            }
                        }
                    }
                  
                    
                }
                   
                Section {
                    HStack {
                        TextField("Name", text: $imageName, prompt: Text("Name"))
                            .textFieldStyle(.roundedBorder)
                    }
                }
                //.padding([.horizontal], 40)
                .padding()
                
                Section {
                    if addLocation {
                        ZStack {
                            Map(coordinateRegion: $region, annotationItems: annotations) {
                                MapMarker(coordinate: $0.location)
                            }
                            .frame(height: 200)
                            
                            Circle()
                                .strokeBorder(.red)
                                .frame(width: 32, height: 32)
                        }
                        .padding()
                        .onTapGesture {
                            annotations = [ImageData.MapAnnotations.init(latitude: region.center.latitude, longitude: region.center.longitude)]
                        }
                        Spacer()
                    }
                    else {
                        //Spacer()
                        Button("Tap to add location") {
                            //
                            addLocation = true
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                        Spacer()
                    }
                }
                .padding(.horizontal, 10)
                
            }
            .sheet(isPresented: $isImagePicker) {
                ImagePicker(images: self.$selectedImages)
            }
            .alert("📸 VizManaged! 🎊", isPresented: $successAlert) {
                Button("OK") {
                    dismiss()
                }
            }
            .alert("You have to select a Viz! 📷", isPresented: $errorAlert) {
                //
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        //
                        if $selectedImages.isEmpty {
                            // show alert
                            errorAlert = true
                        }
                        else {
                            let imageData =
                            ImageData(id: UUID(),
                                      name: imageName,
                                      image: selectedImages,
                                      date: Date.now,
                                      latitude:
                                        annotations.isEmpty ?
                                      region.center.latitude :
                                        annotations[0].latitude,
                                      longitude:
                                        annotations.isEmpty ?
                                      region.center.longitude :
                                        annotations[0].longitude)
                            
                            images.add(image: imageData)
                            successAlert = true
                        }
                        
                    }
                }
                if !selectedImages.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            //
                            isImagePicker = true
                        } label: {
                            Label("Add more", systemImage: "photo.stack")
                        }
                    }
                }
            }
        }
    }
}



struct ImportView_Previews: PreviewProvider {
    static var previews: some View {
        ImportView()
            .environmentObject(ImageModelView.ImagesSample)
    }
}
