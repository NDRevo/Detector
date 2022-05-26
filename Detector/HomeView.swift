//
//  HomeView.swift
//  Detector
//
//  Created by Noé Duran on 5/25/22.
//

import SwiftUI

struct HomeView: View {

    enum Field: Hashable {
        case destinationFolderNameField
    }

    @State var sourceFolderPath: String = ""
    @State var destinationFolderPath: String = ""
    @State var showDocumentPicker: Bool = false
    @State var createFolderInSourcePath: Bool = true
    @State var destinationFolderName: String = ""
    
    @State var detectFaceCheckMark: Bool = false
    @State var detectBodyCheckMark: Bool = false
    @State var detectAnimalCheckMark: Bool = false
    
    @FocusState private var folderField: Field?

    var body: some View {
        
        VStack{
            VStack{
                HStack{
                    Toggle(isOn: $detectFaceCheckMark) {
                        Text("Detect Faces")
                    }
                    .toggleStyle(.checkbox)
                    Spacer()
                    Toggle(isOn: $detectBodyCheckMark) {
                        Text("Detect Human Bodies")
                    }
                    .toggleStyle(.checkbox)
                    Spacer()
                    Toggle(isOn: $detectAnimalCheckMark) {
                        Text("Detect Animals")
                    }
                    .toggleStyle(.checkbox)
                }
                .padding()
                .background {
                    Rectangle()
                        .foregroundColor(Color.secondary)
                        .frame(minHeight: 40)
                }
                .frame(minHeight: 40)
            }
            
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Source Folder Path")
                    HStack {
                        Image(systemName: "folder.badge.gearshape")
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                let sourcePicker = DocumentPicker()
                                sourceFolderPath = sourcePicker.runPicker()
                            }
                            
                            
                        TextField("Path", text: $sourceFolderPath)
                            .disabled(true)
                            .textFieldStyle(.roundedBorder)
                    }
                }
                
                VStack(alignment: .leading){
                    Toggle(isOn: $createFolderInSourcePath) {
                        Text("Create destination folder in source directory?")
                    }
                    .toggleStyle(.checkbox)
                        TextField("Destination Folder Name", text: $destinationFolderName)
                            .textFieldStyle(.roundedBorder)
                            .focused($folderField, equals: .destinationFolderNameField)
                }

                if(!createFolderInSourcePath){
                    VStack(alignment: .leading) {
                        Text("Destination Folder Path")
                        HStack {
                            Image(systemName: "folder.badge.gearshape")
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20)
                                .foregroundColor(.blue)
                                .onTapGesture {
                                    let destinationPicker = DocumentPicker()
                                    destinationFolderPath = destinationPicker.runPicker()
                                }

                            TextField("Path", text: $destinationFolderPath)
                                .disabled(true)
                                .textFieldStyle(.roundedBorder)
                            
                        }
                    }
                }
            }
            .padding()
            .animation(.default, value: createFolderInSourcePath)
            
            Button {
                print("Something")
            } label: {
                Text("Detect Images")
            }
            .animation(.linear, value: createFolderInSourcePath)

            Spacer()
        }
        .background().onTapGesture {
            folderField = nil
        }
        .frame(minWidth: 550, minHeight: 325)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
