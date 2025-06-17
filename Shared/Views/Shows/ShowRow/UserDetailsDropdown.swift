//
//  UserDetailsDropdown.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 1/15/25.
//

import SwiftUI

struct UserDetailsDropdown: View {
    let showId: Int
    
    @EnvironmentObject var modelData: ModelData
    @StateObject var vm = UserDetailsDropdownViewModel()
    
    var loadUserData: Bool?
    var alreadyLoadedMultiUserData: ShowMultiUserData?
    var shouldLoadUserData: Bool {
       if loadUserData != nil {
           return loadUserData!
       } else {
           if (alreadyLoadedMultiUserData != nil) {
               return false
           } else {
               return true
           }
       }
    }
    var multiUserData: ShowMultiUserData? { alreadyLoadedMultiUserData ?? vm.multiUserData }
    var isLoading: Bool { vm.isLoading }
    
    // Navigation state
    @State private var navigateToUserId = ""
    @State private var isNavigationActive = false
    
    var body: some View {
        HStack {
            
            if isLoading {
                UserDetailsDropdownLoading()
            } else if let data = multiUserData, data.hasAnyUsers {
                Menu {
                    // Current user section
                    if let currentUser = data.currentUserData {
                        Section("You") {
                            Button(action: {
                                self.navigateToUserId = currentUser.user.id
                                self.isNavigationActive = true
                            }) {
                                UserDetails(userInfo: currentUser)
                            }
                        }
                    }
                    
                    // Friends section
                    if !data.otherUsersData.isEmpty {
                        Section("Friends") {
                            ForEach(data.otherUsersData, id: \.id) { userInfo in
                                Button(action: {
                                    self.navigateToUserId = userInfo.user.id
                                    self.isNavigationActive = true
                                }) {
                                    UserDetails(userInfo: userInfo)
                                }
                            }
                        }
                    }
                } label: {
                    AvatarsBubbleRow(
                        currentUserInfo: data.currentUserData,
                        otherUsersInfo: data.otherUsersData
                    )
                    .padding(8)
                    .glassEffect(in: .rect(cornerRadius: 16))
//                    .background(
//                        RoundedRectangle(cornerRadius: 8)
//                            .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
//                    )
                }
                .menuStyle(.borderlessButton)
                .menuOrder(.fixed)
                .background(
                    NavigationLink(
                        destination: ProfileDetail(id: navigateToUserId),
                        isActive: $isNavigationActive
                    ) {
                        EmptyView()
                    }
                    .opacity(0)
                )
            }
        }
        .task(id: showId) {
            if (shouldLoadUserData && multiUserData == nil) {
                await vm.loadMultiUserData(showId: showId)
            }
        }
    }
}

struct UserDetailsDropdownLoading: View {
    var body: some View {
        HStack {
            
            AvatarsBubbleRowLoading()
                .padding(8)
                .glassEffect(in: .rect(cornerRadius: 16))
//                .background(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
//                )
        }
    }
}

#Preview {
    UserDetailsDropdownLoading()
//    UserDetailsDropdown(showId: 52)
//        .environmentObject(ModelData())
}
