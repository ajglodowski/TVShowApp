//
//  ShowSquareTile.swift
//  TV Show App
//
//  Created by AJ Glodowski on 6/12/21.
//

import Foundation
import SwiftUI
import SkeletonUI

enum ShowTileType {
    case Default
    case ComingSoon
    case StatusDisplayed
}

struct ShowSquareTile: View {
    
    @StateObject var vm = ShowTileViewModel()
    
    var show: Show
    
    var titleShown: Bool
    
    var tileType: ShowTileType
    
    var ratingShown: Bool?
    var hasRating: Bool { show.addedToUserShows && show.userSpecificValues!.rating != nil }
    
    init(show: Show, titleShown: Bool, belowExtraText: [String]? = nil, belowFontType: Font? = nil, tileType: ShowTileType = .Default) {
        self.show = show
        self.titleShown = titleShown
        self.belowExtraText = belowExtraText
        self.belowFontType = belowFontType
        self.tileType = tileType
    }
    
    var belowExtraText: [String]? // Text below the tile
    var belowFontType: Font?
    
    var showImage: UIImage? { vm.showImage }
    
    private var backgroundColor: Color {
        if (showImage != nil) { return Color(showImage?.averageColor ?? .black) }
        else { return Color(.quaternaryLabel) }
    }
    
    var body: some View {
        
        VStack(alignment:.leading, spacing:0) {
            
            HStack {
                Spacer()
                ShowSquareTileTextAbove(tileType: tileType, show: show)
                Spacer()
            }
            .padding(.horizontal, 10)
            
            Image(uiImage: showImage)
                .resizable()
                .skeleton(with: showImage == nil, shape: .rectangle)
                .scaledToFit()
                .cornerRadius(15)
                .if(show.addedToUserShows && show.userSpecificValues!.status.id == NewSeasonStatusId) {
                    $0.overlay(TileBanner(text: "New\nSeason"),alignment: .bottomLeading)
                }
                .shadow(radius: 5)
                .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
            VStack(alignment: .leading, spacing: 0) {
                if (titleShown) {
                    HStack {
                        Text(show.name)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                            .lineLimit(3)
                    }
                    
                    HStack {
                        Text("\(show.length.rawValue)m • \(show.service.rawValue)")
                            .font(.subheadline)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.leading)
                        if (hasRating && ratingShown != nil && ratingShown!) {
                            Image(systemName: "\(show.userSpecificValues!.rating!.ratingSymbol).fill")
                                .foregroundColor(show.userSpecificValues!.rating!.color)
                        }
                    }
                }
                
                ShowSquareTileTextBelow(tileType: tileType, show: show)
                
                if (belowExtraText != nil) {
                    HStack {
                        VStack {
                            ForEach(belowExtraText!, id:  \.self) { belowLine in
                                if (belowFontType == nil) {
                                    Text(belowLine)
                                        .multilineTextAlignment(.leading)
                                } else {
                                    Text(belowLine)
                                        .font(belowFontType)
                                        .multilineTextAlignment(.leading)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
            
        }
        .frame(width: 150, alignment: .center)
        .foregroundColor(.white)
        .background(backgroundColor)
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal, 5)
        
        .task(id: show.name){
            await vm.loadImage(showName: show.name)
        }
        
    }
}

struct ShowSquareTileTextAbove: View {
    
    var tileType: ShowTileType
    var show: Show
    
    func isOutNow(s: Show) -> Bool {
        if (s.addedToUserShows && s.userSpecificValues!.status.id == ComingSoonStatusId) {
            if ((s.releaseDate != nil) && (s.releaseDate! < Date.now)) { return true }
        }
        return false
    }
    
    func getComingSoonText(s: Show) -> String {
        if (isOutNow(s: s)) { return "Out Now" }
        else {
            let daysTil = Calendar.current.dateComponents([.day], from: Date.now, to: s.releaseDate!).day!
            let daysTilString = "\(daysTil < 1 ? "Within the day" : "\(daysTil) days away" )"
            return  daysTilString
        }
    }
    
    var ComingSoonText: some View {
        let text = getComingSoonText(s: show)
        return (
            VStack (alignment: .center, spacing: 0) {
                Text(text)
                    .font(.headline)
                    .bold()
            }
        )
    }
    
    var body: some View {
        switch tileType {
        case .ComingSoon:
            ComingSoonText
        default:
            EmptyView()
        }
    }
}

struct ShowSquareTileTextBelow: View {
    
    var tileType: ShowTileType
    var show: Show
    
    func isOutNow(s: Show) -> Bool {
        if (s.addedToUserShows && s.userSpecificValues!.status.id == ComingSoonStatusId) {
            if ((s.releaseDate != nil) && (s.releaseDate! < Date.now)) { return true }
        }
        return false
    }
    
    func getComingSoonText(s: Show) -> String? {
        if (!isOutNow(s: s)) {
            let day = DateFormatter()
            day.dateFormat = "EEE"
            let cal = DateFormatter()
            cal.dateFormat = "MMM d"
            let dateString = "\(day.string(from: s.releaseDate!)) \(cal.string(from: s.releaseDate!))"
            return "Coming \(dateString)"
        }
        return nil
    }
    
    var ComingSoonText: some View {
        let text = getComingSoonText(s: show)
        return (
            VStack (alignment: .leading, spacing: 0) {
                if (text != nil) {
                    Text(text)
                        .multilineTextAlignment(.leading)
                        .font(.footnote)
                }
            }
        )
    }
    
    var body: some View {
        switch tileType {
        case .ComingSoon:
            ComingSoonText
        default:
            EmptyView()
        }
    }
}



#Preview {
    var mockShow = Show(from: MockSupabaseShow)
    mockShow.releaseDate = Date() + 100000
    mockShow.name = "The Lord of the Rings The Rings of Power"
    
    let otherMockShow = Show(from: MockSupabaseShow)
    return (
        VStack {
            HStack {
                ShowSquareTile(show: mockShow, titleShown: true)
                ShowSquareTile(show: mockShow, titleShown: true, belowExtraText: ["Below"])
            }
            HStack {
                ShowSquareTile(show: mockShow, titleShown: true, tileType: .ComingSoon)
                ShowSquareTile(show: otherMockShow, titleShown: true, belowExtraText: ["Below"])
            }
            HStack {
                ShowSquareTile(show: mockShow, titleShown: true)
            }
        }
    )
        
}
