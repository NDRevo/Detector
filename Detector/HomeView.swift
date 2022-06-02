//
//  HomeView.swift
//  Detector
//
//  Created by Noé Duran on 5/25/22.
//

import SwiftUI

enum Field: Hashable {
    case destinationFolderNameField
}

struct HomeView: View {

    @StateObject private var viewModel = HomeViewModel()
    @FocusState private var folderField: Field?

    var body: some View {
        VStack {
            CheckBoxesView(detectHumanCM: $viewModel.detectHumanCM, detectAnimalCM: $viewModel.detectAnimalCM)
            VStack(alignment: .leading) {

                FolderPathView(folderPath: $viewModel.sourceFolderPath, titlePathName: "Source Folder Path")

                UserInputSettingView(createFolderInSourcePath: $viewModel.createFolderInSourcePath,
                                     destinationFolderName: $viewModel.destinationFolderName,
                                     folderField: $folderField)

                if(!viewModel.createFolderInSourcePath){
                    FolderPathView(folderPath: $viewModel.destinationFolderPath,
                                   titlePathName: "Destination Folder Path")
                }
            }
            .padding(.horizontal)
            .animation(.default, value: viewModel.createFolderInSourcePath)

            Button {
                let detectionHandler = DetectionHandler()
                viewModel.checkSubmission()
                detectionHandler.runDetectImages(viewModel.sourceFolderPath, viewModel.destinationFolderPath,
                                                 viewModel.destinationFolderName,
                                                 viewModel.detectHumanCM, viewModel.detectAnimalCM)
            } label: {
                Text("Detect Images")
                    .padding(8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                   
            }
            .buttonStyle(.borderless)
            .animation(.linear, value: viewModel.createFolderInSourcePath)

            Spacer()
        }
        .background().onTapGesture { folderField = nil }
        .frame(minWidth: 550, minHeight: 325)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct CheckBoxesView: View {

    @Binding var detectHumanCM: Bool
    @Binding var detectAnimalCM: Bool
    
    //Fix
    @State var humanButtonTapped: Bool = false
    @State var animalButtonTapped: Bool = false

    var body: some View {
        HStack(alignment: .center){
            Spacer()
            Button {
                detectHumanCM.toggle()
                humanButtonTapped.toggle()
            } label: {
                ZStack(alignment:.center){
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 100, height: 40)
                        .foregroundColor(.blue)
                
                    HStack{
                        Image(systemName: humanButtonTapped ? "person.fill" : "person")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 20)
                            .foregroundColor(.white)
                        Text("Humans")
                            .foregroundColor(.white)
                            .bold()
                            .strikethrough(!humanButtonTapped)
                            
                           
                    }
                }
            }
            .buttonStyle(.borderless)
            
            Button {
                detectAnimalCM.toggle()
                animalButtonTapped.toggle()
            } label: {
                ZStack(alignment:.center){
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 100, height: 40)
                        .foregroundColor(.blue)
                
                    HStack{
                        Image(systemName: animalButtonTapped ? "pawprint.fill" : "pawprint")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 20)
                            .foregroundColor(.white)
                        Text("Animals")
                            .foregroundColor(.white)
                            .bold()
                            .strikethrough(!animalButtonTapped)
                    }
                }
            }
            .buttonStyle(.borderless)
            Spacer()
        }
        .padding(.vertical)
    }
}

struct UserInputSettingView: View {

    @Binding var createFolderInSourcePath: Bool
    @Binding var destinationFolderName: String
    var folderField: FocusState<Field?>.Binding

    var body: some View {
        VStack(alignment: .leading){
            Toggle(isOn: $createFolderInSourcePath) {
                Text("Create destination folder in source directory?")
            }
            .toggleStyle(.checkbox)
            HStack{
                Text("Destination Folder Name")
                TextField("Folder Name", text: $destinationFolderName)
                    .textFieldStyle(.roundedBorder)
                    .focused(folderField , equals: .destinationFolderNameField)
            }
        }
    }
}

struct FolderPathView: View {

    @Binding var folderPath: String
    var titlePathName: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(titlePathName)
            HStack {
                Image(systemName: "folder.badge.gearshape")
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        let documentPicker = DocumentPicker()
                        folderPath = documentPicker.runPicker()
                    }

                TextField("Pathname", text: $folderPath)
                    .disabled(true)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }
}
