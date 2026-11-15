//
//  ContentView.swift
//  Navigation - Lesson 1: The Problem with a Simple NavigationLink
//

import SwiftUI

struct DetailView: View {
    var number: Int

    init(number: Int) {
        self.number = number
        print("DetailView \(number) initialized immediately!")
    }

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.orange)

            Text("Detail View \(number)")
                .font(.largeTitle.bold())

            Text("Notice your Xcode console: all rows were initialized eagerly before being tapped!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
        .navigationTitle("Row \(number)")
    }
}

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List(0..<100) { i in
                NavigationLink("Row \(i)") {
                    DetailView(number: i)
                }
            }
            .navigationTitle("Simple NavigationLink")
        }
    }
}

#Preview {
    ContentView()
}
