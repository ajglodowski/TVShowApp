# TVShowApp

This is a side project of mine to experiment with iOS development. It is intended for personal use and replaces my old form of keeping track of TV shows I am watching. It allows for different filters, interesting visuals, and data manipulation. 

# Views

## Home
<img src="Shared/Screenshots/Home.png" width="230" height="500">
<img src="Shared/Screenshots/Home_recording.gif" width="230" height="500">

The home view is the view presented upon opening the app. It displays buttons to navigate to other pages while also showing rows of shows you might want to quickly access.

## Show Detail
<img src="Shared/Screenshots/ShowDetail_top.png" width="230" height="500"> <img src="Shared/Screenshots/ShowDetail_bottom.png" width="230" height="500"> <img src="Shared/Screenshots/Edit_Show_top.png" width="230" height="500"> <img src="Shared/Screenshots/Edit_Show_bottom.png" width="230" height="500">

The show detail view is a page which shows all the details of a particular show, inlcuding a section for its actors, with a dynamic background that matches the color of the show's image. It can be accessed by clicking on a show from the home page or from naviagating to it from the watchlist. This page is also where you can edit the details of the show.

## Watchlist
<img src="Shared/Screenshots/Watchlist.png" width="230" height="500"> <img src="Shared/Screenshots/Watchlist_Applied.png" width="230" height="500">

The watchlist view is the best way to find a show. The page contains a list of shows with icons showing if the show has been watched and/or is still running and tags representing the platform it is on. The page also has filtering functionality for show length and service and includes a search bar to find the show you're looking for.

## Stats
<img src="Shared/Screenshots/Watchlist.png" width="230" height="500"> <img src="Shared/Screenshots/Watchlist_Applied.png" width="230" height="500">

The stats page shows some basic statistics about the show data. The page has a list of the actors which are included in the most shows I've added into the app. It also uses Swift Charts to show a visual representation of how many shows are categorized by each status and how many shows have been added by streaming service.

# Skills used

## Data Fetching

All the data is held in json files in this repo which the app accesses using a REST API. Upon starting the app or when asked to reload, the app fetches the json files and parses them into Swift objects. When it comes time to save the data, it converts it to a JSON object and commits it to the repo. Because of this the number of commits on the repo is inflated.

## Swift Language

The app is written entirely in Swift and SwiftUI as the purpose was for this to be a learning experience for me. The app deals with HTTP requests, parsing the data returned into Swift objects, and manipulating it throughout the app. It gives great exposure to the languages varing data structures, like dates, class heirachy, and enums. The app also explores some of the functionality unique to iOS such as notifcations.

# Future Development:

- Fix Navigation Bugs
- Improve the object relationship between actors and shows as it presents many bugs
- Update the data source to a database or separate repo
- Loading show and/or actor data, such as photos from online (ex: IMDB)

# Acknowledgements
This follows many of the concepts taught in Apple's SwiftUI and IOS tutorials, however significantly expands on them with more views, more complex filters, etc. The process of obtaining dynamic backgrounds on show pages come from here: https://medium.com/swlh/swiftui-read-the-average-color-of-an-image-c736adb43000, but is adapated to fit my project.
