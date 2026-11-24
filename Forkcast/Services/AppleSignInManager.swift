import Foundation
import AuthenticationServices
import Observation

/// Optional Sign in with Apple. Only stores the stable user identifier on the
/// profile; iCloud sync works without it.
@MainActor
@Observable
final class AppleSignInManager {
    private(set) var lastError: String? = nil

    func configure(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName]
    }

    /// Returns the Apple user ID (and given name, the first time) on success.
    func handle(_ result: Result<ASAuthorization, Error>) -> (userId: String, givenName: String?)? {
        switch result {
        case .success(let authorization):
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return nil }
            lastError = nil
            return (credential.user, credential.fullName?.givenName)
        case .failure(let error):
            if let authError = error as? ASAuthorizationError, authError.code == .canceled {
                lastError = nil
            } else {
                lastError = error.localizedDescription
            }
            return nil
        }
    }

    /// Checks the credential is still valid (e.g. not revoked in Settings).
    func isStillAuthorized(userId: String) async -> Bool {
        await withCheckedContinuation { continuation in
            ASAuthorizationAppleIDProvider().getCredentialState(forUserID: userId) { state, _ in
                continuation.resume(returning: state == .authorized)
            }
        }
    }
}
