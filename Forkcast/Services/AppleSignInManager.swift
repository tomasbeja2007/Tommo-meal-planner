import Foundation
import AuthenticationServices
import Observation

/// Optional Sign in with Apple. Only stores the stable user identifier on the
/// profile; iCloud sync works without it.
@MainActor
@Observable
final class AppleSignInManager {
    private(set) var lastError: String? = nil
    private(set) var isSigningIn = false

    func configure(_ request: ASAuthorizationAppleIDRequest) {
        lastError = nil
        isSigningIn = true
        request.requestedScopes = [.fullName, .email]
    }

    /// Apple returns name and email on the first successful authorization.
    func handle(_ result: Result<ASAuthorization, Error>) -> (userId: String, givenName: String?, email: String?)? {
        defer { isSigningIn = false }
        switch result {
        case .success(let authorization):
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return nil }
            lastError = nil
            return (credential.user, credential.fullName?.givenName, credential.email)
        case .failure(let error):
            if let authError = error as? ASAuthorizationError, authError.code == .canceled {
                lastError = nil
            } else {
                lastError = error.localizedDescription
            }
            return nil
        }
    }
}
