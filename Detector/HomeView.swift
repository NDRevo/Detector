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
    @State var destinationFolderName: String = ""

    @State var detectFaceCheckMark: Bool = false
    @State var detectBodyCheckMark: Bool = false
    @State var detectAnimalCheckMark: Bool = false

    @FocusState private var folderField: Field?

    var body: some View {

        VStack {
            CheckBoxesView(detectFaceCM: $detectFaceCheckMark,
                           detectBodyCM: $detectBodyCheckMark,
                           detectAnimalCM: $detectAnimalCheckMark)

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
                print("Something")
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

    @Binding var detectFaceCM: Bool
    @Binding var detectBodyCM: Bool
    @Binding var detectAnimalCM: Bool

    var body: some View {
        HStack{
            Toggle(isOn: $detectFaceCM) {
                Text("Detect Faces")
            }
            .toggleStyle(.checkbox)
            Spacer()
            Toggle(isOn: $detectBodyCM) {
                Text("Detect Human Bodies")
            }
            .toggleStyle(.checkbox)
            Spacer()
            Toggle(isOn: $detectAnimalCM) {
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
            TextField("Destination Folder Name", text: $destinationFolderName)
                .textFieldStyle(.roundedBorder)
                .focused(folderField , equals: .destinationFolderNameField)
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

                TextField("Path", text: $folderPath)
                    .disabled(true)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }
}
