import Vapor


struct SwiftVersion: Content, Equatable {
    var major: Int
    var minor: Int
    var patch: Int
    
    init(_ major: Int, _ minor: Int, _ patch: Int) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }
}


extension SwiftVersion: LosslessStringConvertible {
    init?(_ string: String) {
        let groups = swiftVerRegex.matchGroups(string)
        guard
            groups.count == swiftVerRegex.numberOfCaptureGroups,
            let major = Int(groups[0])
        else { return nil }
        self = .init(major, Int(groups[1]) ?? 0, Int(groups[2]) ?? 0)
    }
    
    var description: String {
        switch (major, minor, patch) {
            case let (major, 0, 0):
                return "\(major)"
            case let (major, minor, 0):
                return "\(major).\(minor)"
            default:
                return "\(major).\(minor).\(patch)"
        }
    }
}


extension SwiftVersion: Comparable {
    static func < (lhs: SwiftVersion, rhs: SwiftVersion) -> Bool {
        if lhs.major != rhs.major { return lhs.major < rhs.major }
        if lhs.minor != rhs.minor { return lhs.minor < rhs.minor }
        return lhs.patch < rhs.patch
    }
}


extension SwiftVersion {
    func isCompatible(with other: SwiftVersion) -> Bool {
        major == other.major && minor == other.minor
    }
}


let swiftVerRegex = NSRegularExpression(#"""
^
v?                              # SPI extension: allow leading 'v'
(?<major>0|[1-9]\d*)
(?:\.
  (?<minor>0|[1-9]\d*)
)?
(?:\.
  (?<patch>0|[1-9]\d*)
)?
$
"""#, options: [.allowCommentsAndWhitespace])
