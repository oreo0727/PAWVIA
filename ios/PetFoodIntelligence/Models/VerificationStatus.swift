enum VerificationStatus: String, Codable, Hashable {
    case unverified = "UNVERIFIED"
    case community = "COMMUNITY"
    case manufacturerVerified = "MANUFACTURER_VERIFIED"
    case packageVerified = "PACKAGE_VERIFIED"

    var label: String {
        switch self {
        case .unverified, .community: "Community Data"
        case .manufacturerVerified: "Manufacturer Verified"
        case .packageVerified: "Package Verified"
        }
    }
}
