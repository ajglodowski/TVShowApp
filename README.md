# TVShowApp

This is a side project of mine to experiment with iOS development. It is intended for personal use and replaces my old form of keeping track of TV shows I am watching. It allows for different filters, interesting visuals, and data manipulation. All the data is held in json files in this repo and is loaded and saved through REST apis.

# Views

## Home
<img src="Shared/Screenshots/Home.png" width="230" height="500">

The home view is the view presented upon opening the app. It displays buttons to navigate to other pages while also showing rows of shows you might want to quickly access.

## Show Detail
<img src="Shared/Screenshots/Show Detail 2.png" width="230" height="500"> <img src="Shared/Screenshots/Show Detail 1.png" width="230" height="500"> <img src="Shared/Screenshots/Edit Show.png" width="230" height="500">

The show detail view is a page which shows all every detail of a particular show with a dynamic background that matches the color of the show's image. It can be accessed by clicking on a show from the home page or from naviagating to it from the watchlist. This page is also where you can edit the details of the show.

## Watchlist
<img src="Shared/Screenshots/Watchlist.png" width="230" height="500"> <img src="Shared/Screenshots/Watchlist Filters.png" width="230" height="500"> <img src="Shared/Screenshots/Watchlist Applied.png" width="230" height="500">

The watchlist view is the best way to find a show. The page contains a list of shows with icons showing if the show has been watched and/or is still running. It also has filters for show length and service and includes a search bar.

# Current TODO:
- Improving saving function
- Navigation bar overhaul

# Acknowledgements
This follows many of the concepts taught in Apple's SwiftUI and IOS tutorials, however significantly expands on them with more views, more complex filters, etc. The process of obtaining dynamic backgrounds on show pages come from here: https://medium.com/swlh/swiftui-read-the-average-color-of-an-image-c736adb43000, but is adapated to fit my project.
