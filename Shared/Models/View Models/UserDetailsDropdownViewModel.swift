//
//  UserDetailsDropdownViewModel.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 1/15/25.
//

import Foundation
import SwiftUI

class UserDetailsDropdownViewModel: ObservableObject {
    
    @Published var multiUserData: ShowMultiUserData? = nil
    @Published var isLoading: Bool = false
    @Published var hasError: Bool = false
    @Published var errorMessage: String? = nil
    
    @MainActor
    private func setLoadingState() {
        self.isLoading = true
        self.hasError = false
        self.errorMessage = nil
        self.multiUserData = nil
    }
    
    @MainActor
    private func setMultiUserData(data: ShowMultiUserData) {
        self.multiUserData = data
        self.isLoading = false
        self.hasError = false
        self.errorMessage = nil
    }
    
    @MainActor
    private func setErrorState(message: String) {
        self.hasError = true
        self.isLoading = false
        self.errorMessage = message
    }
    
    func loadMultiUserData(showId: Int) async {
        // Don't reload if we already have data for this show and we're not loading
        if let existingData = multiUserData, 
           existingData.showId == showId && 
           !isLoading {
            return
        }
        
        await setLoadingState()
        let data = await getMultiUserShowData(showId: showId)
        await setMultiUserData(data: data)
    }
} 
