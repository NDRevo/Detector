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
    var numOfFaceImagesDetected = 0
    var numOfNoResultImages = 0
    var numOfNonImageFiles = 0
    var isFace: Bool = false
    var isHuman: Bool = false

    private func isImageFace(imageURL: URL, directoryURL: URL, orientation: CGImagePropertyOrientation, _ dHumanCM: Bool, _ dAnimalCM: Bool){
        let imageRequestHandler = VNImageRequestHandler(url: imageURL, orientation: orientation, options: [:])
        
        var requests: [VNImageBasedRequest] = []
        let detectHumanRectanglesRequest    = VNDetectHumanRectanglesRequest(completionHandler: self.handleHumanDetectionRequest)
        let detectFaceRectanglesRequest     = VNDetectFaceRectanglesRequest(completionHandler: self.handleFaceDetectionRequest)
        
        if dHumanCM {
            requests.append(detectHumanRectanglesRequest)
        }

        do {
            try imageRequestHandler.perform(requests)
            if isFace || isHuman{
                numOfFaceImagesDetected += 1
                try FileManager.default.moveItem(atPath: imageURL.path, toPath: directoryURL.path + "/" + (imageURL.path.components(separatedBy: "/").last ?? ""))
                isFace = false
                isHuman = false
            }
        } catch let error as NSError {
           //Failed to perform image request
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

    private func handleFaceDetectionRequest(request: VNRequest?, error: Error?){
        if let requestError = error as? NSError{
            print(requestError)
            return
        }
        if let results = request?.results as? [VNFaceObservation] {
            for _ in results {
                isFace = true
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
