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

            VStack(alignment: .leading, spacing: 20) {

                FolderPathView(folderPath: $viewModel.sourceFolderPath, titlePathName: "Source Folder Path")

                UserInputSettingView(createFolderInSourcePath: $viewModel.createFolderInSourcePath,
                                     destinationFolderName: $viewModel.destinationFolderName,
                                     folderField: $folderField)

                if(!viewModel.createFolderInSourcePath){
                    FolderPathView(folderPath: $viewModel.destinationFolderPath,
                                   titlePathName: "Destination Folder Path")
                }
            }
            .padding()
            .animation(.default, value: viewModel.createFolderInSourcePath)

            Button {
                let detectionHandler = DetectionHandler()
                viewModel.checkSubmission()
                detectionHandler.runDetectImages(viewModel.sourceFolderPath, viewModel.destinationFolderPath,
                                                 viewModel.destinationFolderName,
                                                 viewModel.detectHumanCM, viewModel.detectAnimalCM)
            } label: {
                Text("Detect Images")
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
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

    var body: some View {
        HStack(alignment: .center){
            Spacer()
            Toggle(isOn: $detectHumanCM) {
                Text("Detect Humans")
            }
            .toggleStyle(.checkbox)
            Toggle(isOn: $detectAnimalCM) {
                Text("Detect Animals")
            }
            .toggleStyle(.checkbox)
            Spacer()
        }
        .padding()
        .background {
            Rectangle()
                .foregroundColor(Color.secondary)
                .frame(minHeight: 40)
        }
        .frame(minHeight: 40)
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
