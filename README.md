# Lesson 5: How to Save NavigationPath using Codable

In this lesson from Paul Hudson's **100 Days of SwiftUI** (Day 44 / Project 9), we learn how to persist the entire navigation backstack to disk using `Codable` and restore it when the user returns.

---

## 📱 Screenshot

<p align="center">
  <img src="screenshots/lesson_05.png" width="300" alt="Lesson 5 Screenshot" />
</p>

---

## 💾 Saving & Loading with PathStore

`NavigationPath` has a built-in `.codable` property that returns an optional `NavigationPath.CodableRepresentation`.

### Saving:
```swift
func save() {
    guard let representation = path.codable else { return }
    let data = try? JSONEncoder().encode(representation)
    try? data?.write(to: savePath)
}
```

### Loading:
```swift
init() {
    if let data = try? Data(contentsOf: savePath),
       let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) {
        path = NavigationPath(decoded)
        return
    }
    path = NavigationPath()
}
```

Whenever the user relaunches the app, they resume on the exact screen they left!
