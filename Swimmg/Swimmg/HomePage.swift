import SwiftUI

struct HomePage: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    
                    // Placeholder for looping video
                    Rectangle()
                        .fill(Color.blue.opacity(0.5))
                        .frame(height: 200)
                        .overlay(
                            Text("🏊‍♂️ Cool Swimming Video Here")
                                .font(.headline)
                                .foregroundColor(.white)
                        )
                        .cornerRadius(15)
                        .padding(.top)
                    
                    // Quick Stats / Promos
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Quick Stats")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("🏆 300+ swimmers coached this summer!")
                        Text("🔥 Top 3 weekly performers!")
                        Text("🔓 Unlock VIP lessons by winning top performer!")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    
                    // Testimonials
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Testimonials")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("“This app helped me improve my swim time by 20%!”")
                            .italic()
                        Text("“Amazing coaches and super easy booking!”")
                            .italic()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    
                    // Navigation Buttons
                    VStack(spacing: 20) {
                        NavigationLink(destination: Text("Coach Login Screen")) {
                            Text("Coach Login")
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        
                        NavigationLink(destination: Text("User Booking Screen")) {
                            Text("User Bookings")
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Home")
        }
    }
}

#Preview {
    HomePage()
}

