//
//  DetectionHandler.swift
//  Detector
//
//  Created by Noé Duran on 5/26/22.
//

import Foundation
import Vision
import AppKit

class DetectionHandler {
    var numOfImagesDetected = 0
    var numOfNoResultImages = 0
    var numOfNonImageFiles = 0
    var isHuman: Bool   = false
    var isAnimal: Bool  = false

    private func isImageFace(imageURL: URL, directoryURL: URL, orientation: CGImagePropertyOrientation, _ dHumanCM: Bool, _ dAnimalCM: Bool){
        let imageRequestHandler = VNImageRequestHandler(url: imageURL, orientation: orientation, options: [:])
        
        var requests: [VNImageBasedRequest] = []
        let detectHumanRectanglesRequest    = VNDetectHumanRectanglesRequest(completionHandler: self.handleHumanDetectionRequest)
        //let detectFaceRectanglesRequest     = VNDetectFaceRectanglesRequest(completionHandler: self.handleFaceDetectionRequest)
        let detectAnimalRectanglesRequest   = VNRecognizeAnimalsRequest(completionHandler: self.handleRecognizeAnimalRequest)

        if dHumanCM {
            requests.append(detectHumanRectanglesRequest)
        }
        if dAnimalCM {
            requests.append(detectAnimalRectanglesRequest)
        }

        do {
            try imageRequestHandler.perform(requests)
            if isHuman || isAnimal{
                numOfImagesDetected += 1
                try FileManager.default.moveItem(atPath: imageURL.path, toPath: directoryURL.path + "/" + (imageURL.path.components(separatedBy: "/").last ?? ""))
                isHuman     = false
                isAnimal    = false
            }
        } catch {
           //Failed to perform image request
            print(error)
        }
    }

    private func handleHumanDetectionRequest(request: VNRequest?, error: Error?){
        if let requestError = error as? NSError{
            print(requestError)
            return
        }
        if let results = request?.results as? [VNHumanObservation] {
            for _ in results {
                isHuman = true
                return
            }
            numOfNoResultImages += 1
        }
    }

    private func handleRecognizeAnimalRequest(request: VNRequest?, error: Error?){
        if let requestError = error as? NSError{
            print(requestError)
            return
        }
        if let results = request?.results as? [VNRecognizedObjectObservation] {
            for _ in results {
                isAnimal = true
                return
            }
            numOfNoResultImages += 1
        }
    }

    func runDetectImages(_ sourcePath: String, _ destinationPath: String, _ folderName: String, _ dHumanCM: Bool, _ dAnimalCM: Bool) {
        var isDir:ObjCBool = true

        if FileManager.default.fileExists(atPath: sourcePath, isDirectory: &isDir) {

                let newDirectoryPath =  destinationPath + "/"+folderName
                print(newDirectoryPath)

                if !FileManager.default.fileExists(atPath: newDirectoryPath, isDirectory: &isDir) {
                    do {
                        try FileManager.default.createDirectory(at: URL(fileURLWithPath: newDirectoryPath), withIntermediateDirectories: false)
                    } catch {
                        print(error)
                    }
                }

                for file in FileManager.default.listFiles(path: sourcePath){
                    if let _ = NSImage(contentsOfFile: file.path){
                        isImageFace(imageURL: URL(fileURLWithPath: file.path), directoryURL: URL(fileURLWithPath: newDirectoryPath), orientation: .up, dHumanCM, dAnimalCM)
                    } else {
                        numOfNonImageFiles += 1
                    }
                }
        }
    }
}

//From: https://stackoverflow.com/questions/27721418/getting-list-of-files-in-documents-folder
extension FileManager {
    func listFiles(path: String) -> [URL] {
        let baseurl: URL = URL(fileURLWithPath: path)
        var urls = [URL]()
        enumerator(atPath: path)?.forEach({ (e) in
            guard let s = e as? String else { return }
            let relativeURL = URL(fileURLWithPath: s, relativeTo: baseurl)
            let url = relativeURL.absoluteURL
            urls.append(url)
        })
        return urls
    }
}
