import SwiftUI

struct HomePage: View {
    @State private var animate = false
    var body: some View {
        NavigationView {
            ZStack {
                // Animated water-like background
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.cyan.opacity(0.5), Color.blue.opacity(0.7)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                .overlay(
                    WaveView()
                        .fill(Color.white.opacity(0.2))
                        .offset(y: animate ? 100 : -100)
                        .animation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true), value: animate)
                )
                
                VStack {
                    // Header
                    HStack {
                        Text("Home")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 30) {
                            // Video placeholder
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.2))
                                .frame(height: 220)
                                .overlay(
                                    Image(systemName: "play.circle.fill")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.white)
                                )
                                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)

                            // Quick Stats
                            StatsCard()

                            // Testimonials
                            TestimonialCard()

                            // Buttons
                            ActionButtons()
                        }
                        .padding()
                    }
                }
                .onAppear { animate.toggle() }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}


//MARK: - Wave Shape for Background Animation
struct WaveView: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let wavelength = rect.width / 1.5
        path.move(to: CGPoint(x: 0, y: rect.midY))
        for x in stride(from: 0, through: rect.width, by: 1) {
            let relativeX = x / wavelength
            let y = sin(relativeX * .pi * 2 + .pi) * 20 + rect.midY
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        return path
    }
}


//MARK: - Quick Stats Card
struct StatsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Quick Stats")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            HStack(spacing: 20) {
                StatItem(icon: "trophy.fill", value: "300+", label: "Coached")
                StatItem(icon: "flame.fill", value: "Top 3", label: "Performers")
                StatItem(icon: "star.fill", value: "VIP", label: "Unlocked")
            }
        }
        .padding()
        .background(BlurView(style: .systemUltraThinMaterialDark))
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

//MARK: - Individual Stat Item
struct StatItem: View {
    let icon: String
    let value: String
    let label: String
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.yellow)
            Text(value)
                .font(.headline)
                .foregroundColor(.white)
            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
    }
}


//MARK: - Testimonials Card
struct TestimonialCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Testimonials")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            VStack(spacing: 10) {
                QuoteView(text: "This app improved my swim time by 20%!")
                QuoteView(text: "Revolutionary experience, love the coaching!")
            }
        }
        .padding()
        .background(BlurView(style: .systemUltraThinMaterialDark))
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

//MARK: - Individual Quote View
struct QuoteView: View {
    let text: String
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "quote.opening")
                .foregroundColor(.white.opacity(0.7))
            Text(text)
                .foregroundColor(.white.opacity(0.9))
                .italic()
        }
    }
}


//MARK: - Action Buttons
struct ActionButtons: View {
    var body: some View {
        VStack(spacing: 20) {
            NavigationLink(destination: Text("Coach Login Screen")) {
                Text("Coach Login")
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
            NavigationLink(destination: Text("User Booking Screen")) {
                Text("User Bookings")
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.cyan.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
        }
    }
}

//MARK: - Blur View
import UIKit
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

#Preview {
    HomePage()
}

