# Lesson 2: Handling Navigation the Smart Way with navigationDestination()

In this lesson from Paul Hudson's **100 Days of SwiftUI** (Day 43 / Project 9), we solve the eager loading problem using type-safe, value-driven navigation with `.navigationDestination(for:)`.

---

## 📱 Screenshot

<p align="center">
  <img src="screenshots/lesson_02.png" width="300" alt="Lesson 2 Screenshot" />
</p>

---

## 💡 The Smart Way: Data-Driven Navigation

Instead of putting destination views directly inside `NavigationLink`, we separate **what data is being passed** from **how it should be displayed**:

1. **Pass a value:**
   ```swift
   NavigationLink(student.name, value: student)
   ```
2. **Define destination lazily on the stack:**
   ```swift
   .navigationDestination(for: Student.self) { student in
       // This view is instantiated ONLY when the user taps!
       VStack {
           Text(student.name)
           Text("Age: \(student.age)")
       }
   }
   ```

### Requirements:
- Any custom model passed as a navigation value must conform to the `Hashable` protocol.
