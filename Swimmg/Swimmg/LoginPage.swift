import SwiftUI
import AuthenticationServices
import GoogleSignIn

struct LoginPage: View {
    @Environment(\.openURL) var openURL: OpenURLAction

    var body: some View {
        NavigationView {
            ZStack {
                // MARK: Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.cyan.opacity(0.6)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 40) {
                    Spacer()

                    // MARK: App Title / Logo
                    Text("Swimmg")
                        .font(.system(size: 48, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)

                    // MARK: Google Sign-In Button
                    Button(action: handleGoogleSignIn) {
                        HStack {
                            Image("google_logo") // Add your "google_logo" asset
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text("Sign in with Google")
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                    }
                    .padding(.horizontal, 30)

                    // MARK: Apple Sign-In Button
                    SignInWithAppleButton(
                        .signIn,
                        onRequest: { request in
                            request.requestedScopes = [.fullName, .email]
                        },
                        onCompletion: { result in
                            switch result {
                            case .success(let auth):
                                if let cred = auth.credential as? ASAuthorizationAppleIDCredential {
                                    print("✅ Apple user ID: \(cred.user)")
                                }
                            case .failure(let error):
                                print("❌ Apple Sign-In error: \(error.localizedDescription)")
                            }
                        }
                    )
                    .signInWithAppleButtonStyle(.white)
                    .frame(height: 45)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                    .padding(.horizontal, 30)

                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }

    // MARK: Google Sign-In Handler
    private func handleGoogleSignIn() {
        // TODO: Replace with your actual clientID from Google Console
        let clientID = "<YOUR_GOOGLE_CLIENT_ID>"
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)

        // Find root view controller
        guard let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let rootVC = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController
        else {
            print("❌ Unable to get root view controller for sign-in")
            return
        }

        // Present sign-in and unwrap result
        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { signInResult, error in
            if let error = error {
                print("❌ Google Sign-In error: \(error.localizedDescription)")
                return
            }
            guard let result = signInResult, let profile = result.user.profile else {
                print("❌ Google Sign-In: No result or no profile")
                return
            }
            print("✅ Google user signed in: \(profile.name ?? profile.email)")
        }
    }
}

#Preview {
    LoginPage()
}

