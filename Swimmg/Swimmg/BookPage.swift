import SwiftUI

// MARK: - Water Motion Background (Homepage Style)
struct WaveBackground: View {
    @State private var phase: CGFloat = 0
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.cyan.opacity(0.5), Color.blue.opacity(0.7)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            BookingWaveView()
                .fill(Color.white.opacity(0.2))
                .offset(y: phase)
                .onAppear {
                    withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                        phase = 100
                    }
                }
        }
    }
}

struct BookingWaveView: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let wavelength = rect.width / 1.5
        path.move(to: CGPoint(x: 0, y: rect.midY))
        for x in stride(from: 0, through: rect.width, by: 1) {
            let relativeX = x / wavelength
            let y = sin(relativeX * .pi * 2) * 20 + rect.midY
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        return path
    }
}

// MARK: - Booking Page
struct BookingPage: View {
    @State private var displayedMonth: Date = Date()
    @State private var selectedDate: Date?
    @State private var bookedTime: Date?
    @State private var showConfirmation = false

    private let calendar = Calendar.current
    private let monthFormatter: DateFormatter = {
        let f = DateFormatter(); f.dateFormat = "MMMM yyyy"; return f
    }()
    private let dayFormatter: DateFormatter = {
        let f = DateFormatter(); f.dateFormat = "d"; return f
    }()
    private let weekdaySymbols = Calendar.current.shortWeekdaySymbols

    private var monthGrid: [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: displayedMonth),
              let firstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start)
        else { return [] }
        let start = firstWeek.start
        let end = calendar.date(byAdding: .day, value: 42, to: start)!
        return stride(from: start, to: end, by: 86400).map { d in
            calendar.isDate(d, equalTo: displayedMonth, toGranularity: .month) ? d : nil
        }
    }

    private var timeslots: [Date] {
        guard let date = selectedDate else { return [] }
        return (6...20).compactMap { hour in
            calendar.date(bySettingHour: hour, minute: 0, second: 0, of: date)
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                WaveBackground()
                VStack(spacing: 20) {
                    HStack {
                        Button(action: prevMonth) {
                            Image(systemName: "chevron.left").foregroundColor(.black)
                        }
                        Spacer()
                        Text(monthFormatter.string(from: displayedMonth))
                            .font(.title2).fontWeight(.bold).foregroundColor(.black)
                        Spacer()
                        Button(action: nextMonth) {
                            Image(systemName: "chevron.right").foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal)

                    HStack(spacing: 0) {
                        ForEach(weekdaySymbols, id: \.self) { day in
                            Text(day)
                                .font(.caption2)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                        }
                    }

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                        ForEach(monthGrid.indices, id: \.self) { idx in
                            if let date = monthGrid[idx] {
                                Text(dayFormatter.string(from: date))
                                    .frame(maxWidth: .infinity, minHeight: 32)
                                    .background(isSameDay(date, selectedDate) ? Color.black.opacity(0.1) : Color.clear)
                                    .cornerRadius(6)
                                    .onTapGesture { selectedDate = date; bookedTime = nil }
                                    .foregroundColor(.black)
                            } else {
                                Color.clear.frame(height: 32)
                            }
                        }
                    }
                    .padding(.horizontal)

                    if selectedDate != nil {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(timeslots, id: \.self) { slot in
                                    let isSelected = bookedTime == slot
                                    Text(DateFormatter.localizedString(from: slot, dateStyle: .none, timeStyle: .short))
                                        .padding(.vertical,8).padding(.horizontal,12)
                                        .background(isSelected ? Color.blue : Color.white)
                                        .foregroundColor(isSelected ? .white : .black)
                                        .cornerRadius(8)
                                        .onTapGesture { bookedTime = slot; showConfirmation = true }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    Spacer()
                }
                .padding()
                .background(Color.white.opacity(0.9))
                .cornerRadius(20)
                .padding()
            }
            .navigationBarHidden(true)
            .alert("Confirm Booking", isPresented: $showConfirmation) {
                Button("Confirm") { /* perform booking */ }
                Button("Cancel", role: .cancel) {}
            } message: {
                if let time = bookedTime {
                    Text("Book on \(DateFormatter.localizedString(from: time, dateStyle: .medium, timeStyle: .short))?")
                        .foregroundColor(.black)
                }
            }
        }
    }

    private func prevMonth() {
        if let prev = calendar.date(byAdding: .month, value: -1, to: displayedMonth) {
            displayedMonth = prev
        }
    }
    private func nextMonth() {
        if let next = calendar.date(byAdding: .month, value: 1, to: displayedMonth) {
            displayedMonth = next
        }
    }
    private func isSameDay(_ a: Date, _ b: Date?) -> Bool {
        guard let b = b else { return false }
        return calendar.isDate(a, inSameDayAs: b)
    }
}

struct BookingPage_Previews: PreviewProvider {
    static var previews: some View { BookingPage() }
}

