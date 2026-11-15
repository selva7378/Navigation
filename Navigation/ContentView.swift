//
//  ContentView.swift
//  Navigation - Main Branch: Navigation Wrap-Up Challenge & Master Hub
//

import SwiftUI

// MARK: - Models (Hashable Conformance for NavigationDestination)

enum NavigationRoute: Hashable {
    case addExpense
    case missionList
    case branchesGuide
}

struct ExpenseItem: Identifiable, Hashable {
    let id: UUID
    var name: String
    var type: String
    var amount: Double

    init(id: UUID = UUID(), name: String, type: String, amount: Double) {
        self.id = id
        self.name = name
        self.type = type
        self.amount = amount
    }
}

struct MissionItem: Identifiable, Hashable {
    let id: Int
    let name: String
    let launchDate: String
    let badge: String
    let crew: [CrewMemberItem]
}

struct CrewMemberItem: Identifiable, Hashable {
    let id: String
    let name: String
    let role: String
}

// MARK: - Persistent Path Store (Codable NavigationPath)

@Observable
class PathStore {
    var path: NavigationPath {
        didSet {
            save()
        }
    }

    private let savePath = URL.documentsDirectory.appending(path: "SavedNavigationPath")

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
            print("Failed to save path: \(error.localizedDescription)")
        }
    }

    func reset() {
        path = NavigationPath()
    }
}

// MARK: - Challenge 1 & 2: Push-based Add View with Hidden Back Button & Editable Nav Title

struct AddExpenseDestinationView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var expenses: [ExpenseItem]

    @State private var expenseName = "New Expense"
    @State private var expenseType = "Personal"
    @State private var amountText = ""
    @State private var showAlert = false

    let types = ["Business", "Personal"]

    var body: some View {
        Form {
            Section("Expense Details") {
                HStack {
                    Text("Name:")
                        .foregroundStyle(.secondary)
                    Text(expenseName)
                        .bold()
                }

                Text("💡 Challenge 2: Tap the navigation title above to edit the expense name directly in the bar!")
                    .font(.caption)
                    .foregroundStyle(.blue)

                Picker("Type", selection: $expenseType) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }

                TextField("Amount", text: $amountText)
                    .keyboardType(.decimalPad)
            }

            Section("Challenge 1 Requirements") {
                Label("Push navigation via NavigationLink (no sheet)", systemImage: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                Label("Hidden system back button (forces Cancel/Save)", systemImage: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                Label("Explicit dismiss() via toolbar buttons", systemImage: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            }
        }
        .navigationTitle($expenseName)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundStyle(.red)
            }

            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let amount = Double(amountText) ?? 0.0
                    let newExpense = ExpenseItem(name: expenseName, type: expenseType, amount: amount)
                    expenses.append(newExpense)
                    dismiss()
                }
                .bold()
            }
        }
    }
}

// MARK: - Challenge 3: Hashable Navigation Destinations (Moonshot Style)

struct MissionDetailDestinationView: View {
    let mission: MissionItem

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: mission.badge)
                    .font(.system(size: 80))
                    .foregroundStyle(.indigo)
                    .padding()

                Text(mission.name)
                    .font(.largeTitle.bold())

                Text("Launch Date: \(mission.launchDate)")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                Divider()
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Crew Members (Tap for lazy CrewDetailView):")
                        .font(.headline)
                        .padding(.horizontal)

                    ForEach(mission.crew) { member in
                        NavigationLink(value: member) {
                            HStack {
                                Image(systemName: "person.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(.indigo)

                                VStack(alignment: .leading) {
                                    Text(member.name)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    Text(member.role)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.tertiary)
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle(mission.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CrewDetailDestinationView: View {
    let crewMember: CrewMemberItem

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "person.crop.circle.badge.checkmark")
                .font(.system(size: 90))
                .foregroundStyle(.indigo)

            Text(crewMember.name)
                .font(.title.bold())

            Text("Role: \(crewMember.role)")
                .font(.title3)
                .foregroundStyle(.secondary)

            Text("This view was loaded lazily using:\n.navigationDestination(for: CrewMemberItem.self)")
                .font(.footnote)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding()
        .navigationTitle(crewMember.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Lesson Branches Guide Sheet/View

struct LessonBranchesGuideView: View {
    let branches = [
        ("lesson-01-simple-navigationlink-problem", "Eager loading issue with basic NavigationLink"),
        ("lesson-02-navigation-destination", "Value-based navigation with navigationDestination"),
        ("lesson-03-programmatic-navigation", "Controlling stack depth and pop-to-root via [Int]"),
        ("lesson-04-navigation-path", "Heterogeneous types with type-erased NavigationPath"),
        ("lesson-05-codable-navigation-path", "State serialization to disk using Codable representation"),
        ("lesson-06-customizing-navigation-bar", "Navigation bar styling, toolbar backgrounds & tint"),
        ("lesson-07-editable-title-and-toolbars", "Two-way editable title binding & toolbar placements")
    ]

    var body: some View {
        List {
            Section("Lesson Reference Branches") {
                ForEach(branches, id: \.0) { branch, description in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(branch)
                            .font(.system(.body, design: .monospaced))
                            .bold()
                            .foregroundStyle(.indigo)
                        Text(description)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 2)
                }
            }
        }
        .navigationTitle("Lesson Branches")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Main ContentView Hub

struct ContentView: View {
    @State private var pathStore = PathStore()
    @State private var expenses = [
        ExpenseItem(name: "Domain Registration", type: "Business", amount: 14.99),
        ExpenseItem(name: "Coffee & Lunch", type: "Personal", amount: 18.50)
    ]

    let sampleMissions = [
        MissionItem(
            id: 11,
            name: "Apollo 11",
            launchDate: "July 16, 1969",
            badge: "moon.stars.fill",
            crew: [
                CrewMemberItem(id: "armstrong", name: "Neil Armstrong", role: "Commander"),
                CrewMemberItem(id: "aldrin", name: "Buzz Aldrin", role: "Lunar Module Pilot"),
                CrewMemberItem(id: "collins", name: "Michael Collins", role: "Command Module Pilot")
            ]
        ),
        MissionItem(
            id: 8,
            name: "Apollo 8",
            launchDate: "December 21, 1968",
            badge: "globe.americas.fill",
            crew: [
                CrewMemberItem(id: "borman", name: "Frank Borman", role: "Commander"),
                CrewMemberItem(id: "lovell", name: "Jim Lovell", role: "Command Module Pilot"),
                CrewMemberItem(id: "anders", name: "William Anders", role: "Lunar Module Pilot")
            ]
        )
    ]

    var body: some View {
        NavigationStack(path: $pathStore.path) {
            List {
                // Section 1: Wrap-Up Challenges 1 & 2
                Section {
                    ForEach(expenses) { expense in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(expense.name)
                                    .font(.headline)
                                Text(expense.type)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(expense.amount, format: .currency(code: "USD"))
                                .font(.subheadline.bold())
                        }
                    }

                    NavigationLink(value: NavigationRoute.addExpense) {
                        Label("Add Expense (Challenge 1 & 2)", systemImage: "plus.circle.fill")
                            .foregroundStyle(.indigo)
                            .font(.body.bold())
                    }
                } header: {
                    Text("Challenges 1 & 2: Push Navigation & Editable Title")
                } footer: {
                    Text("Replaces sheets with NavigationLink, hides back button, and allows inline navigation title editing.")
                }

                // Section 2: Wrap-Up Challenge 3
                Section {
                    ForEach(sampleMissions) { mission in
                        NavigationLink(value: mission) {
                            HStack(spacing: 12) {
                                Image(systemName: mission.badge)
                                    .font(.title2)
                                    .foregroundStyle(.indigo)
                                    .frame(width: 32)

                                VStack(alignment: .leading) {
                                    Text(mission.name)
                                        .font(.headline)
                                    Text(mission.launchDate)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                } header: {
                    Text("Challenge 3: Hashable Navigation (Moonshot)")
                } footer: {
                    Text("Uses NavigationLink(value:) + navigationDestination for typed, lazy loading.")
                }

                // Section 3: Reference Branches Hub
                Section("All 7 Lesson Branches") {
                    NavigationLink(value: NavigationRoute.branchesGuide) {
                        Label("Browse 7 Lesson Branches Index", systemImage: "list.bullet.rectangle.portrait")
                            .foregroundStyle(.primary)
                    }
                }

                // Section 4: Path State Controls
                Section("Active Path State") {
                    HStack {
                        Text("Current Stack Depth:")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("\(pathStore.path.count)")
                            .bold()
                    }

                    if pathStore.path.count > 0 {
                        Button("Pop to Root (Reset Path)") {
                            pathStore.reset()
                        }
                        .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Navigation Wrap-Up")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.indigo.opacity(0.1), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(value: NavigationRoute.addExpense) {
                        Image(systemName: "plus")
                    }
                }
            }
            // Typed Navigation Destinations
            .navigationDestination(for: NavigationRoute.self) { route in
                switch route {
                case .addExpense:
                    AddExpenseDestinationView(expenses: $expenses)
                case .missionList:
                    Text("Mission List")
                case .branchesGuide:
                    LessonBranchesGuideView()
                }
            }
            .navigationDestination(for: MissionItem.self) { mission in
                MissionDetailDestinationView(mission: mission)
            }
            .navigationDestination(for: CrewMemberItem.self) { crewMember in
                CrewDetailDestinationView(crewMember: crewMember)
            }
        }
    }
}

#Preview {
    ContentView()
}
