//
//  HomeViewModel.swift
//  Detector
//
//  Created by Noé Duran on 5/26/22.
//

import Foundation

class HomeViewModel: ObservableObject {

    @Published var destinationFolderName: String = "Detected Images"
    @Published var sourceFolderPath: String = ""
    @Published var destinationFolderPath: String = ""
    @Published var createFolderInSourcePath: Bool = true
    @Published var showDocumentPicker: Bool = false

    @Published var detectHumanCM: Bool = true
    @Published var detectAnimalCM: Bool = false
    
    @Published var isShowingAlert: Bool = false
    
    
    func checkSubmission(){
        if sourceFolderPath.isEmpty {
           isShowingAlert = true
        }
        if createFolderInSourcePath {
            destinationFolderPath = sourceFolderPath
        }
        if destinationFolderName.isEmpty {
            destinationFolderName = "Detected Images"
        }
    }
}
