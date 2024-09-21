//
//  ShowTileViewModel.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/4/22.
//

import Foundation
import Swift
import SwiftUI
import Firebase
import FirebaseStorage

class ShowTileViewModel: ObservableObject {
    
    @Published var showImage: UIImage? = nil
    
    let fetcherInstance = ShowTileImageFetcher.shared
    
    @MainActor
    func setShowImage(image: UIImage?) {
        self.showImage = image
    }

    func loadImage(showName: String) async {
        do {
            let fetchedImage = try await fetcherInstance.fetchImage(showName: showName)
            await setShowImage(image: fetchedImage)
        } catch {
            //dump(error)
        }
    }
    
}
