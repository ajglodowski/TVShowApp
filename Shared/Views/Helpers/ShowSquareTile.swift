import SwiftUI
import SkeletonUI

enum ShowTileType {
    case Default
    case ComingSoon
    case StatusDisplayed
}

// Helper component for text above the tile
struct ShowSquareTileTextAbove: View {
    var tileType: ShowTileType
    var show: Show
    
    func isOutNow(s: Show) -> Bool {
        if (s.addedToUserShows && s.userSpecificValues?.status.id == ComingSoonStatusId) {
            if ((s.releaseDate != nil) && (s.releaseDate! < Date.now)) { return true }
        }
        return false
    }
    
    func getComingSoonText(s: Show) -> String {
        if (isOutNow(s: s)) { return "Out Now" }
        else {
            let daysTil = Calendar.current.dateComponents([.day], from: Date.now, to: s.releaseDate!).day!
            let daysTilString = "\(daysTil < 1 ? "Within the day" : "\(daysTil) days away" )"
            return daysTilString
        }
    }
    
    var body: some View {
        switch tileType {
        case .ComingSoon:
            let text = getComingSoonText(s: show)
            Text(text)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
        default:
            EmptyView()
        }
    }
}

// Helper component for text below the tile
struct ShowSquareTileTextBelow: View {
    var tileType: ShowTileType
    var show: Show
    
    func isOutNow(s: Show) -> Bool {
        if (s.addedToUserShows && s.userSpecificValues?.status.id == ComingSoonStatusId) {
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
    
    var body: some View {
        switch tileType {
        case .ComingSoon:
            if let text = getComingSoonText(s: show) {
                Text(text)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
        default:
            EmptyView()
        }
    }
}

struct ShowSquareTile: View {
    @StateObject var vm = ShowTileViewModel()
    
    var show: Show
    var titleShown: Bool
    var tileType: ShowTileType
    var ratingShown: Bool?
    var hasRating: Bool { show.addedToUserShows && show.userSpecificValues?.rating != nil }
    var belowExtraText: [String]?
    var belowFontType: Font?
    
    init(show: Show, titleShown: Bool, belowExtraText: [String]? = nil, belowFontType: Font? = nil, tileType: ShowTileType = .Default) {
        self.show = show
        self.titleShown = titleShown
        self.belowExtraText = belowExtraText
        self.belowFontType = belowFontType
        self.tileType = tileType
    }
    
    var showImage: UIImage? { vm.showImage }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Image container
            if let image = showImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .skeleton(with: true, shape: .rectangle)
                    .frame(width: 150, height: 150)
            }
            
            // Gradient overlay
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0.9),
                    Color.black.opacity(0.4),
                    Color.black.opacity(0)
                ]),
                startPoint: .bottom,
                endPoint: .top
            )
            
            // New Season badge if applicable
            if show.addedToUserShows && show.userSpecificValues?.status.id == NewSeasonStatusId {
                Text("New\nSeason")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(6)
                    .background(Color.red.opacity(0.8))
                    .cornerRadius(4)
                    .padding(8)
            }
            
            // Content overlay
            VStack(alignment: .leading, spacing: 4) {
                Spacer()
                
                // Above text using the helper component
                ShowSquareTileTextAbove(tileType: tileType, show: show)
                    .padding(.bottom, tileType == .ComingSoon ? 4 : 0)
                
                // Title
                if titleShown {
                    Text(show.name)
                        .font(.subheadline.weight(.medium))
                        .lineLimit(1)
                        .foregroundColor(.white)
                }
                
                // Length and service info
                if titleShown {
                    HStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.system(size: 12))
                            Text("\(show.length.rawValue)m")
                                .font(.caption)
                                .lineLimit(1)
                        }
                        .foregroundColor(.white.opacity(0.6))
                        
                        Text("•")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text(show.service.rawValue)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                        
                        if hasRating && ratingShown == true {
                            Image(systemName: "\(show.userSpecificValues!.rating!.ratingSymbol).fill")
                                .foregroundColor(show.userSpecificValues!.rating!.color)
                                .font(.system(size: 12))
                        }
                    }
                }
                
                // Below text using the helper component
                ShowSquareTileTextBelow(tileType: tileType, show: show)
                
                // Extra text below
                if let extraText = belowExtraText {
                    VStack(alignment: .leading, spacing: 2) {
                        ForEach(extraText, id: \.self) { text in
                            Text(text)
                                .font(belowFontType ?? .caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .padding(.top, 2)
                }
            }
            .padding(12)
        }
        .frame(width: 150, height: 150)
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding (.horizontal, 5)
        .task(id: show.pictureUrl) {
            if let url = show.pictureUrl {
                await vm.loadImage(pictureUrl: url)
            }
        }
    }
}

struct ShowSquareTileLoading: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .skeleton(with: true, shape: .rectangle)
        }
        .frame(width: 150, height: 150)
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal, 5)
    }
}

// Preview
#Preview {
    var mockShow = Show(from: MockSupabaseShow)
    mockShow.releaseDate = Date() + 100000
    mockShow.pictureUrl = "The Lord of the Rings The Rings of Power"
    mockShow.name = "The Lord of the Rings The Rings of Power"
    
    return VStack(spacing: 20) {
        HStack(spacing: 16) {
            ShowSquareTile(show: mockShow, titleShown: true)
            ShowSquareTile(show: mockShow, titleShown: true, tileType: .ComingSoon)
        }
        
        HStack(spacing: 16) {
            ShowSquareTile(
                show: mockShow,
                titleShown: true,
                belowExtraText: ["Popular", "New Season"]
            )
        }
            
        ScrollView(.horizontal) {
                HStack(spacing: 16) {
                    ShowSquareTile(
                        show: mockShow,
                        titleShown: true,
                        belowExtraText: ["Up to Date but show has ended"]
                    )
                    ShowSquareTile(
                        show: mockShow,
                        titleShown: true,
                        belowExtraText: ["New season is on the way"]
                    )
                    ShowSquareTile(
                        show: mockShow,
                        titleShown: true,
                        belowExtraText: ["Up to Date but not on latest season"]
                    )
                    ShowSquareTileLoading()
            }
        }
    }
}
