//
//  ContentView.swift
//  Navigation - Lesson 4: Navigating to different data types using NavigationPath
//

import SwiftUI

struct ContentView: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section("Numbers (Int)") {
                    Button("Show Number 556") {
                        path.append(556)
                    }
                    Button("Show Number 1337") {
                        path.append(1337)
                    }
                }

                Section("Strings") {
                    Button("Show String 'Hello Moonshot'") {
                        path.append("Hello Moonshot")
                    }
                    Button("Show String 'SwiftUI Rocks'") {
                        path.append("SwiftUI Rocks")
                    }
                }

                Section("Multi-Step Chain") {
                    Button("Push Int (42) then String ('Deep Link')") {
                        path.append(42)
                        path.append("Deep Link")
                    }
                }
            }
            .navigationTitle("Multi-Type Path")
            .navigationDestination(for: Int.self) { number in
                VStack(spacing: 16) {
                    Image(systemName: "number.circle.fill")
                        .font(.system(size: 70))
                        .foregroundStyle(.purple)

                    Text("Integer View")
                        .font(.title.bold())

                    Text("\(number)")
                        .font(.system(size: 48, weight: .heavy, design: .monospaced))
                }
                .navigationTitle("Int: \(number)")
            }
            .navigationDestination(for: String.self) { text in
                VStack(spacing: 16) {
                    Image(systemName: "text.quote")
                        .font(.system(size: 70))
                        .foregroundStyle(.teal)

                    Text("String View")
                        .font(.title.bold())

                    Text(text)
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
                .navigationTitle(text)
            }
        }
    }
}

#Preview {
    ContentView()
}
