
import SwiftUI

// MARK: – Data Models

struct Session: Identifiable {
    let id = UUID()
    let date: String
    let dist: String
    let dur: String
}

let sampleSessions = [
    Session(date: "May 1",  dist: "4 km", dur: "1h 12m"),
    Session(date: "Apr 28", dist: "2 km", dur: "34m")
]

struct Badge: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
}

let sampleBadges = [
    Badge(name: "First Open-Water", icon: "drop.fill"),
    Badge(name: "100 km Total",      icon: "flame.fill")
]

struct Integration: Identifiable {
    let id = UUID()
    let name: String
    var synced: Bool
}

// MARK: – Profile View

struct ProfileView: View {
    // Dummy state – replace these with your view-model bindings
    @State private var displayName     = "Gonzalo Vegas"
    @State private var membershipLevel = "Premium"
    @State private var streakDays      = 12
    @State private var goalProgress: CGFloat = 0.6

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // 1. Personal & Account Info
                    accountHeader
                    
                    // 2. Swim Metrics Snapshot
                    MetricsCard(
                        totalDistance: "1,230 km",
                        personalBests: ["100 m Free": "00:58", "200 m Back": "02:10"],
                        avgPace:       "1:45 /100 m",
                        workouts:      78
                    )
                    
                    // 3. Goals & Progress
                    goalsSection
                    
                    // 4. Upcoming Bookings & History
                    bookingsSection
                    
                    // 5. Achievements & Badges
                    BadgeGallery(badges: sampleBadges)
                    
                    // 6. Health & Integrations
                    IntegrationCard(integrations: [
                        Integration(name: "HealthKit", synced: true),
                        Integration(name: "Fitbit",   synced: false),
                        Integration(name: "Strava",   synced: true)
                    ])
                    
                    // 7. Social & Coaching
                    SocialCard(friendsCount: 8, unreadMessages: 2)
                    
                    // 8. Subscription & Billing
                    SubscriptionCard(
                        plan:            membershipLevel,
                        nextPayment:     "Jun 1, 2025",
                        purchaseHistory: ["Extra Lesson (Apr 12)","Nutrition Pack (Mar 30)"]
                    )
                }
                .padding(.vertical)
                .padding(.horizontal, 16)
            }
            .navigationTitle("Profile")
            .background(Color(.secondarySystemBackground).ignoresSafeArea())
        }
    }

    // MARK: – Subviews

    private var accountHeader: some View {
        HStack(spacing: 16) {
            Image("avatar")
                .resizable()
                .clipShape(Circle())
                .frame(width: 80, height: 80)
                .shadow(radius: 4)

            VStack(alignment: .leading, spacing: 8) {
                Text(displayName)
                    .font(.title2).bold()

                HStack {
                    Text(membershipLevel.uppercased())
                        .font(.caption).bold()
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)

                    Spacer()

                    NavigationLink("Edit ▶︎", destination: SettingsView())
                        .font(.footnote)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground).opacity(0.9))
        .cornerRadius(12)
        .shadow(radius: 2)
        .stickyHeader()
    }

    private var goalsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Current Goal").font(.headline)
            ProgressView(value: goalProgress) {
                Text("Swim 50 km this month")
            }
            .progressViewStyle(LinearProgressViewStyle(tint: .blue))

            HStack {
                VStack {
                    Text("\(streakDays)")
                        .font(.largeTitle).bold()
                    Text("Day Streak")
                        .font(.caption)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Next Milestone").font(.footnote)
                    Text("5 km in one session")
                        .font(.subheadline).bold()
                }
            }
        }
        .padding()
        .background(Color(.systemBackground).opacity(0.9))
        .cornerRadius(12)
    }

    private var bookingsSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Next Lesson")
                    .font(.headline)
                Spacer()
                NavigationLink("See All", destination: BookingsView())
            }
            BookingRow(
                date:     "May 10, 2025 • 10:00 AM",
                coach:    "Coach Amy",
                location: "Aventura Pool"
            )

            Divider()

            Text("Recent Sessions")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            ForEach(sampleSessions) { s in
                SessionRow(session: s)
            }
        }
        .padding()
        .background(Color(.systemBackground).opacity(0.9))
        .cornerRadius(12)
    }
}

// MARK: – Metrics Card

struct MetricsCard: View {
    let totalDistance: String
    let personalBests: [String: String]
    let avgPace:       String
    let workouts:      Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Swim Metrics").font(.headline)

            HStack {
                StatView(label: "Distance", value: totalDistance)
                StatView(label: "Pace",     value: avgPace)
            }

            HStack {
                ForEach(personalBests.sorted(by: { $0.key < $1.key }), id: \.key) { stroke, time in
                    StatView(label: stroke, value: time)
                }
            }

            StatView(label: "Sessions", value: "\(workouts)")
        }
        .padding()
        .background(Color(.systemBackground).opacity(0.9))
        .cornerRadius(12)
    }
}

struct StatView: View {
    let label: String, value: String
    var body: some View {
        VStack {
            Text(value).font(.headline)
            Text(label).font(.caption)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: – Booking & Session Rows

struct BookingRow: View {
    let date: String, coach: String, location: String
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(date).font(.subheadline)
                Text("\(coach) • \(location)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
    }
}

struct SessionRow: View {
    let session: Session
    var body: some View {
        HStack {
            Text(session.date)
            Spacer()
            Text(session.dist)
            Text(session.dur)
                .foregroundColor(.secondary)
        }
        .font(.subheadline)
    }
}

// MARK: – Badges

struct BadgeGallery: View {
    let badges: [Badge]
    var body: some View {
        VStack(alignment: .leading) {
            Text("Achievements").font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(badges) { b in
                        VStack {
                            Image(systemName: b.icon)
                                .font(.largeTitle)
                            Text(b.name)
                                .font(.caption)
                        }
                        .padding()
                        .background(Color(.systemBackground).opacity(0.9))
                        .cornerRadius(12)
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
}

// MARK: – Integrations

struct IntegrationCard: View {
    @State var integrations: [Integration]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Health & Integrations").font(.headline)
            ForEach($integrations) { $i in
                HStack {
                    Text(i.name)
                    Spacer()
                    Toggle("", isOn: $i.synced)
                        .labelsHidden()
                }
            }
        }
        .padding()
        .background(Color(.systemBackground).opacity(0.9))
        .cornerRadius(12)
    }
}

// MARK: – Social & Subscription

struct SocialCard: View {
    let friendsCount: Int, unreadMessages: Int
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Label("\(friendsCount) Friends", systemImage: "person.2.fill")
                Spacer()
                Label("\(unreadMessages) Msgs",  systemImage: "envelope.fill")
            }
            Button("Share Progress") {
                // share action
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color(.systemBackground).opacity(0.9))
        .cornerRadius(12)
    }
}

struct SubscriptionCard: View {
    let plan: String, nextPayment: String, purchaseHistory: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Subscription").font(.headline)
            Text("\(plan) • Renews \(nextPayment)")
                .font(.subheadline)
            Button("Manage Subscription") { }
                .buttonStyle(.bordered)
            Divider()
            Text("Purchase History").font(.subheadline)
            ForEach(purchaseHistory, id: \.self) { item in
                Text("• \(item)").font(.caption)
            }
        }
        .padding()
        .background(Color(.systemBackground).opacity(0.9))
        .cornerRadius(12)
    }
}

// MARK: – Sticky Header Modifier

extension View {
    func stickyHeader() -> some View {
        self.modifier(StickyModifier())
    }
}

struct StickyModifier: ViewModifier {
    func body(content: Content) -> some View {
        GeometryReader { geo in
            content
                .position(x: geo.size.width/2,
                          y: max(geo.frame(in: .global).minY, geo.size.height/2))
        }
    }
}

// MARK: – Dummy Destination Screens

struct SettingsView: View {
    var body: some View {
        Text("Settings").navigationTitle("Settings")
    }
}

struct BookingsView: View {
    var body: some View {
        Text("All Bookings").navigationTitle("Bookings")
    }
}

// MARK: – Preview

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

