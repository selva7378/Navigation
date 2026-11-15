//
//  ContentView.swift
//  Navigation - Lesson 2: Handling navigation the smart way with navigationDestination()
//

import SwiftUI

struct Student: Hashable, Identifiable {
    var id = UUID()
    var name: String
    var age: Int
}

struct ContentView: View {
    let students = [
        Student(name: "Harry Potter", age: 17),
        Student(name: "Hermione Granger", age: 17),
        Student(name: "Ron Weasley", age: 17)
    ]

    var body: some View {
        NavigationStack {
            List(students) { student in
                NavigationLink(student.name, value: student)
            }
            .navigationTitle("Hogwarts Students")
            .navigationDestination(for: Student.self) { student in
                VStack(spacing: 16) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(.indigo)

                    Text(student.name)
                        .font(.largeTitle.bold())

                    Text("Age: \(student.age)")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
                .navigationTitle(student.name)
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    ContentView()
}
