# NewsReader test project

- [NewsReader test project](#news-reader)
  - [About](#about)
  - [Architecture](#architecture)
  - [Database](#database)
  - [Image caching](#image-caching)


## About
Simple rss reader. Extra news sources can be easily added. 

## Architecture
Main project architecture is Model-View-ViewModel + Coordinator (MVVM+C). The MVVM pattern is designed to separate concerns and improve the testability and reusability of code. It consists of three key components: Model, View, ViewModel. The Coordinators pattern helps in managing the navigation and flow of screens within an app by encapsulating the navigation logic into separate coordinator objects.

## Database
Realm is a noSQL mobile database that runs directly inside devices. Realm is using for news data persistence and managing when to update news views to reflect the latest data.

## Image caching
Image caching is based on NSCache's interaction with the Concurrency framework, which provides a declarative Swift API for processing values ​​over time.
