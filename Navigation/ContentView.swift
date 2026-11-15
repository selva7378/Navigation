//
//  ContentView.swift
//  Navigation - Lesson 7: Editable navigation titles and toolbar item placement
//

import SwiftUI

struct ContentView: View {
    @State private var title = "SwiftUI Projects"
    @State private var notes = [
        "Review NavigationStack",
        "Implement navigationDestination",
        "Test toolbar item placements"
    ]
    @State private var statusMessage = "Tap the title above to edit it inline."

    var body: some View {
        NavigationStack {
            List {
                Section("Dynamic Title") {
                    HStack {
                        Text("Current Title:")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(title)
                            .bold()
                    }

                    Text("Tip: In iOS 16+, binding a String state variable to .navigationTitle($title) makes the inline title user-editable upon tapping.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section("Project Notes") {
                    ForEach(notes, id: \.self) { note in
                        Label(note, systemImage: "checklist")
                    }
                }

                Section("Status Log") {
                    Text(statusMessage)
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                }
            }
            .navigationTitle($title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Reset") {
                        title = "SwiftUI Projects"
                        statusMessage = "Reset title to default."
                    }
                }

                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        notes.append("New Note #\(notes.count + 1)")
                        statusMessage = "Added a new note."
                    } label: {
                        Label("Add Note", systemImage: "plus")
                    }

                    Button {
                        statusMessage = "Saved project: '\(title)'"
                    } label: {
                        Label("Save", systemImage: "square.and.arrow.down")
                    }
                }

                ToolbarItem(placement: .bottomBar) {
                    Text("\(notes.count) items in project")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
