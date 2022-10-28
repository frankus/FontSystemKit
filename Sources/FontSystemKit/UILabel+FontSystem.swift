import UIKit

private var fontSystemKey: Void?

extension UILabel {
    @objc dynamic public var fontSystem: FontSystem? {
        get {
            return objc_getAssociatedObject(self, &fontSystemKey) as? FontSystem
        }
        set {
            objc_setAssociatedObject(self, &fontSystemKey, newValue, .OBJC_ASSOCIATION_RETAIN)

            guard let textStyleString = self.font.fontDescriptor.object(forKey: UIFontDescriptor.AttributeName.textStyle) as? String else {
                print("FontSystemKit: Font for \(self.debugDescription) has a missing or invalid textStyle.")
                return
            }

            let textStyle = UIFont.TextStyle(rawValue: textStyleString)

            if let fontSystem = newValue {
                self.font = fontSystem.preferredFont(forTextStyle: textStyle)
            } else {
                self.font = .preferredFont(forTextStyle: textStyle)
            }
        }
    }
}
