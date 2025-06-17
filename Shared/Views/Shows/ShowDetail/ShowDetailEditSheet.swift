//
//  ShowDetailEditSheet.swift
//  TV Show App
//
//  Created by AJ Glodowski on 4/27/21.
//

import SwiftUI

struct ShowDetailEditSheet: ViewModifier {
    let show: Show?
    let showId: Int
    let uid: String?
    @Binding var isPresented: Bool
    @Binding var showEdited: Show
    @EnvironmentObject var modelData: ModelData
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                NavigationView {
                    ShowDetailEdit(isPresented: $isPresented, show: $showEdited)
                        .navigationTitle(show?.name ?? "Loading Show")
                        .navigationBarItems(
                            leading: Button("Cancel") {
                                showEdited = show ?? Show(id: -1)
                                isPresented = false
                            },
                            trailing: Button("Done") {
                                if (showEdited != show) {
                                    showEdited.lastUpdated = Date()
                                    Task {
                                        let updatedShow = SupabaseShow(from: showEdited)
                                        let success = await updateShow(show: updatedShow)
                                        if (success) {
                                            await modelData.reloadAllShowData(showId: showId, userId: uid)
                                            isPresented = false
                                        }
                                    }
                                }
                            }
                        )
                }
            }
    }
}

extension View {
    func showDetailEditSheet(
        show: Show?,
        showId: Int,
        uid: String?,
        isPresented: Binding<Bool>,
        showEdited: Binding<Show>
    ) -> some View {
        modifier(ShowDetailEditSheet(
            show: show,
            showId: showId,
            uid: uid,
            isPresented: isPresented,
            showEdited: showEdited
        ))
    }
} 