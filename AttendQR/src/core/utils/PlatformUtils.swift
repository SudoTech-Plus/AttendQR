import SwiftUI

#if canImport(UIKit)
import UIKit
public typealias PlatformImage = UIImage
#elseif canImport(AppKit)
import AppKit
public typealias PlatformImage = NSImage
#else
// Fallback for other platforms if needed
public typealias PlatformImage = Any
#endif

extension PlatformImage {
    /// Loads a system icon in a platform-agnostic way
    static func system(_ name: String) -> PlatformImage {
        #if canImport(UIKit)
        return UIImage(systemName: name) ?? UIImage()
        #elseif canImport(AppKit)
        return NSImage(systemSymbolName: name, accessibilityDescription: nil) ?? NSImage()
        #else
        return PlatformImage() // This case shouldn't happen with the aliases above
        #endif
    }
}

extension Image {
    /// Helper to initialize a SwiftUI Image from a platform-specific image (UIImage or NSImage)
    init(platformImage: PlatformImage) {
        #if canImport(UIKit)
        self.init(uiImage: platformImage)
        #elseif canImport(AppKit)
        self.init(nsImage: platformImage)
        #else
        self.init(systemName: "questionmark.circle")
        #endif
    }
}

/// A wrapper for icons to avoid raw platform-specific types in view inputs
public enum AppIcon {
    case system(String)
    case custom(PlatformImage)
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .system(let name):
            Image(systemName: name)
        case .custom(let image):
            Image(platformImage: image)
        }
    }
}
