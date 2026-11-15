//
//  ContentView.swift
//  Navigation - Lesson 3: Programmatic navigation with NavigationStack
//

import SwiftUI

struct DetailView: View {
    var number: Int
    @Binding var path: [Int]

    var body: some View {
        VStack(spacing: 20) {
            Text("Screen #\(number)")
                .font(.largeTitle.bold())

            Button("Push Next Random Number") {
                path.append(Int.random(in: 1...1000))
            }
            .buttonStyle(.borderedProminent)

            Button("Pop Back to Root (Home)") {
                path.removeAll()
            }
            .buttonStyle(.bordered)
            .tint(.red)
        }
        .padding()
        .navigationTitle("Number: \(number)")
    }
}

struct ContentView: View {
    @State private var path = [Int]()

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 24) {
                Text("Current Path Depth: \(path.count)")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                Button("Jump to 42") {
                    path.append(42)
                }
                .buttonStyle(.borderedProminent)

                Button("Jump Straight to [10, 20, 30]") {
                    path = [10, 20, 30]
                }
                .buttonStyle(.bordered)
            }
            .navigationTitle("Programmatic Nav")
            .navigationDestination(for: Int.self) { number in
                DetailView(number: number, path: $path)
            }
        }
    }
}

#Preview {
    ContentView()
}
