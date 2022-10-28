import UIKit

/// Defines a set of fonts for each system text style.
public class FontSystem: NSObject {

    /// The font to use as a template for labels whose text style specifies a regular weight.
    public var regularFont: UIFont

    /// Creates a font system populated with the preferred system font for each text style.
    public override init() {
        self.regularFont = .preferredFont(forTextStyle: .body)

        super.init()

        for textStyle in Self.systemTextStyles {
            self.textStyleFonts[textStyle] = .preferredFont(forTextStyle: textStyle)
        }
    }

    /// Creates a font system populated with the specified font name and suffixes for each text style.
    /// - Parameters:
    ///   - baseName: The base name of the font.
    ///   - regularSuffix: The suffix for the name of the regular weight of the font.
    ///   - ultraLightSuffix: The suffix for the name of the ultra light weight of the font.
    ///   - thinSuffix: The suffix for the name of the thin weight of the font.
    ///   - lightSuffix: The suffix for the name of the light weight of the font.
    ///   - mediumSuffix: The suffix for the name of the medium weight of the font.
    ///   - semiboldSuffix: The suffix for the name of the semibold weight of the font.
    ///   - boldSuffix: The suffix for the name of the bold weight of the font.
    ///   - heavySuffix: The suffix for the name of the heavy weight of the font.
    ///   - blackSuffix: The suffix for the name of the black weight of the font.
    public init?(baseName: String,
                 regularSuffix: String = "",
                 ultraLightSuffix: String? = nil,
                 thinSuffix: String? = nil,
                 lightSuffix: String? = nil,
                 mediumSuffix: String? = nil,
                 semiboldSuffix: String? = nil,
                 boldSuffix: String? = nil,
                 heavySuffix: String? = nil,
                 blackSuffix: String? = nil
    ) {
        guard let regularFontDescriptor = Self.fontDescriptor(with: baseName, suffix: regularSuffix) else {
            return nil
        }

        self.regularFont = UIFont(descriptor: regularFontDescriptor, size: 17.0)

        super.init()

        let ultraLightFontDescriptor = Self.fontDescriptor(with: baseName, suffix: ultraLightSuffix)
        let thinFontDescriptor = Self.fontDescriptor(with: baseName, suffix: thinSuffix)
        let lightFontDescriptor = Self.fontDescriptor(with: baseName, suffix: lightSuffix)
        let mediumFontDescriptor = Self.fontDescriptor(with: baseName, suffix: mediumSuffix)
        let semiboldFontDescriptor = Self.fontDescriptor(with: baseName, suffix: semiboldSuffix)
        let boldFontDescriptor = Self.fontDescriptor(with: baseName, suffix: boldSuffix)
        let heavyFontDescriptor = Self.fontDescriptor(with: baseName, suffix: heavySuffix)
        let blackFontDescriptor = Self.fontDescriptor(with: baseName, suffix: blackSuffix)

        self.fontDescriptorsForWeight[.ultraLight] = ultraLightFontDescriptor ?? thinFontDescriptor ?? lightFontDescriptor ?? regularFontDescriptor
        self.fontDescriptorsForWeight[.thin] = thinFontDescriptor ?? lightFontDescriptor ?? regularFontDescriptor
        self.fontDescriptorsForWeight[.light] = lightFontDescriptor ?? regularFontDescriptor
        self.fontDescriptorsForWeight[.medium] = mediumFontDescriptor ?? regularFontDescriptor
        self.fontDescriptorsForWeight[.semibold] = semiboldFontDescriptor ?? boldFontDescriptor ?? regularFontDescriptor
        self.fontDescriptorsForWeight[.bold] = boldFontDescriptor ?? heavyFontDescriptor ?? semiboldFontDescriptor ?? blackFontDescriptor ?? regularFontDescriptor
        self.fontDescriptorsForWeight[.heavy] = heavyFontDescriptor ?? blackFontDescriptor ?? boldFontDescriptor ?? semiboldFontDescriptor ?? regularFontDescriptor
        self.fontDescriptorsForWeight[.black] = blackFontDescriptor ?? heavyFontDescriptor ?? boldFontDescriptor ?? semiboldFontDescriptor ?? regularFontDescriptor

        let traitCollection = UITraitCollection(preferredContentSizeCategory: .medium)

        for textStyle in Self.systemTextStyles {
            let systemFontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle, compatibleWith: traitCollection)
            let unsizedFontDescriptor = textStyle == .headline ? self.fontDescriptorsForWeight[.semibold] ?? regularFontDescriptor : regularFontDescriptor
            let sizedFont = UIFont(descriptor: unsizedFontDescriptor, size: systemFontDescriptor.pointSize)

            self.setFont(sizedFont, forTextStyle: textStyle, compatibleWith: traitCollection)
        }
    }

    /// Overrides the font for particular text style using the specified font.
    /// - Parameters:
    ///   - font: The font to use for the specified text style.
    ///   - textStyle: The text style to override.
    ///   - traitCollection: An optional `UITraitCollection` object used to create the scaled font with `UIFontMetrics`.
    public func setFont(_ font: UIFont, forTextStyle textStyle: UIFont.TextStyle, compatibleWith traitCollection: UITraitCollection? = nil) {
        self.textStyleFonts[textStyle] = UIFontMetrics(forTextStyle: textStyle).scaledFont(for: font, compatibleWith: traitCollection)
    }

    /// Overrides the system's default font weight for a text style.
    /// - Parameters:
    ///   - weight: The font weight to use.
    ///   - textStyle: The text style to override.
    public func useWeight(_ weight: UIFont.Weight, forTextStyle textStyle: UIFont.TextStyle) {
        let fontDescriptor = self.fontDescriptorsForWeight[weight] ?? self.regularFont.fontDescriptor
        let size = self.textStyleFonts[textStyle]?.fontDescriptor.pointSize ?? 17.0
        let sizedFont = UIFont(descriptor: fontDescriptor, size: size)

        self.setFont(sizedFont, forTextStyle: textStyle)
    }

    internal var fontDescriptorsForWeight = [UIFont.Weight: UIFontDescriptor]()
    internal var textStyleFonts = [UIFont.TextStyle: UIFont]()

    internal func preferredFont(forTextStyle textStyle: UIFont.TextStyle) -> UIFont {
        return self.textStyleFonts[textStyle] ?? self.regularFont
    }

    internal static func fontDescriptor(with baseName: String, suffix: String?) -> UIFontDescriptor? {
        if let suffix {
            return UIFontDescriptor(name: baseName + suffix, size: 17.0)
        } else {
            return nil
        }
    }

    internal static var systemTextStyles: [UIFont.TextStyle] = [
        .largeTitle,
        .title1,
        .title2,
        .title3,
        .headline,
        .subheadline,
        .body,
        .callout,
        .footnote,
        .caption1,
        .caption2,
    ]
}
