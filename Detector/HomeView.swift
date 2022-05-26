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

    @State var sourceFolderPath: String = ""
    @State var destinationFolderPath: String = ""
    @State var showDocumentPicker: Bool = false
    @State var createFolderInSourcePath: Bool = true
    @State var destinationFolderName: String = "Detected Images"

    @State var detectHumanCM: Bool = false
    @State var detectAnimalCM: Bool = false

    @FocusState private var folderField: Field?

    var body: some View {

        VStack {
            CheckBoxesView(detectHumanCM: $detectHumanCM,
                           detectAnimalCM: $detectAnimalCM)

            VStack(alignment: .leading, spacing: 20) {

                FolderPathView(folderPath: $sourceFolderPath,
                               titlePathName: "Source Folder Path")

                UserInputSettingView(createFolderInSourcePath: $createFolderInSourcePath,
                                     destinationFolderName: $destinationFolderName,
                                     folderField: $folderField)

                if(!createFolderInSourcePath){
                    FolderPathView(folderPath: $destinationFolderPath,
                                   titlePathName: "Destination Folder Path")
                }
            }
            .padding()
            .animation(.default, value: createFolderInSourcePath)

            Button {
                let detectionHandler = DetectionHandler()
                if createFolderInSourcePath {
                    destinationFolderPath = sourceFolderPath
                }
                if destinationFolderName.isEmpty {
                    destinationFolderName = "Detected Images"
                }
                detectionHandler.runDetectImages(sourceFolderPath,
                                                 destinationFolderPath,
                                                 destinationFolderName,
                                                 detectHumanCM,
                                                 detectAnimalCM)
            } label: {
                Text("Detect Images")
            }
            .animation(.linear, value: createFolderInSourcePath)

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
