//
//  ContentView.swift
//  Navigation - Lesson 6: Customizing the navigation bar appearance
//

import SwiftUI

struct CustomDetailView: View {
    var title: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "paintpalette.fill")
                .font(.system(size: 60))
                .foregroundStyle(.indigo)

            Text("Custom Back Button Screen")
                .font(.title2.bold())

            Text("The system back button is hidden on this view using .navigationBarBackButtonHidden(true). You must tap the button below to pop back.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            Button("Dismiss Back to Root") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .tint(.indigo)
        }
        .padding()
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.indigo.opacity(0.15), for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Custom Back")
                    }
                    .font(.body.bold())
                    .foregroundStyle(.indigo)
                }
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Lesson Concepts") {
                    Text("1. toolbarBackground: sets a tint color")
                    Text("2. toolbarColorScheme: enforces light/dark text")
                    Text("3. navigationBarTitleDisplayMode: inline vs large")
                    Text("4. navigationBarBackButtonHidden: custom dismiss")
                }

                Section("Interactive Demonstration") {
                    NavigationLink("Go to Custom Detail View") {
                        CustomDetailView(title: "Custom Detail")
                    }
                }

                Section("Scrollable Content (Observe Nav Bar)") {
                    ForEach(1...30, id: \.self) { i in
                        Label("Item #\(i)", systemImage: "star.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Styled Nav Bar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.indigo, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

#Preview {
    ContentView()
}
