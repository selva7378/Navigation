//
//  ContentView.swift
//  Navigation - Lesson 5: How to save NavigationPath using Codable
//

import SwiftUI

@Observable
class PathStore {
    var path: NavigationPath {
        didSet {
            save()
        }
    }

    private let savePath = URL.documentsDirectory.appending(path: "SavedPath")

    init() {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) {
                path = NavigationPath(decoded)
                return
            }
        }

        path = NavigationPath()
    }

    func save() {
        guard let representation = path.codable else { return }

        do {
            let data = try JSONEncoder().encode(representation)
            try data.write(to: savePath)
        } catch {
            print("Failed to save navigation state: \(error.localizedDescription)")
        }
    }
}

struct DetailView: View {
    var number: Int

    var body: some View {
        VStack(spacing: 20) {
            Text("Level: \(number)")
                .font(.largeTitle.bold())

            NavigationLink("Push Next Level", value: Int.random(in: 1...1000))
                .buttonStyle(.borderedProminent)

            Text("Kill and restart the app — your navigation stack will persist automatically!")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding()
        }
        .navigationTitle("Level \(number)")
    }
}

struct ContentView: View {
    @State private var pathStore = PathStore()

    var body: some View {
        NavigationStack(path: $pathStore.path) {
            DetailView(number: 0)
                .navigationDestination(for: Int.self) { number in
                    DetailView(number: number)
                }
        }
    }
}

#Preview {
    ContentView()
}
