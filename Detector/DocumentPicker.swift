//
//  DocumentPicker.swift
//  Detector
//
//  Created by Noé Duran on 5/25/22.
//

import Foundation
import SwiftUI

class DocumentPicker {
    let dialog = NSOpenPanel()

    func configurePicker(){
        dialog.showsResizeIndicator     = true
        dialog.showsHiddenFiles         = false
        dialog.allowsMultipleSelection  = false
        dialog.canChooseDirectories     = true
        dialog.canChooseFiles           = false
    }
    
    func runPicker() -> String {
        configurePicker()
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url

            if (result != nil) {
                let path: String = result!.path
                return path
            }
        } else {
            // User clicked on "Cancel"
            return ""
        }
        return ""
    }
}
