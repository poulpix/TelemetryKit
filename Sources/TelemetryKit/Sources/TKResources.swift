//
//  TKResources.swift
//  TelemetryKit
//
//  Created by Romain on 05/08/2019.
//  Copyright © 2019 Poulpix. All rights reserved.
//

import Foundation
import SwiftUI
#if os(iOS)
import UIKit
#endif
#if os(macOS)
import AppKit
#endif

public enum TKError: Error {
	
	case resourceNotFound(resourceName: String)
	case fontError(fontName: String)
	case unknownError
	
}

public enum TKFormula1FontType: String, CaseIterable {
	
	case regular = "Formula1-Display-Regular"
	case bold = "Formula1-Display-Bold"
	case italic = "Formula1-Display-Italic"
	case wide = "Formula1-Display-Wide"
	
}

public struct TKResources {
	
	#if os(iOS)
	public static func loadAllFonts() {
		TKFormula1FontType.allCases.forEach {
			try? UIFont.registerFont(named: $0.rawValue)
		}
	}
	
	public static func image(named imageName: String) throws -> UIImage {
		guard let image = UIImage(named: imageName, in: Bundle.module, compatibleWith: nil) else {
			throw TKError.resourceNotFound(resourceName: imageName)
		}
		return image
	}
	
	public static func font(named fontName: String, ofSize fontSize: CGFloat = 12) throws -> UIFont {
		do {
			let fontURL = try resourceURL(named: fontName, ofType: "otf")
			let fontData = try Data(contentsOf: fontURL)
			guard let dataProvider = CGDataProvider(data: fontData as CFData) else {
				throw TKError.fontError(fontName: fontName)
			}
			let cgFont = CGFont(dataProvider)!
			var error: Unmanaged<CFError>?
			if !CTFontManagerRegisterGraphicsFont(cgFont, &error) {
				guard let e: Error = error?.takeRetainedValue(), (e as NSError).code == CTFontManagerError.alreadyRegistered.rawValue, (e as NSError).domain == kCTFontManagerErrorDomain as String, let font = UIFont(name: cgFont.postScriptName! as String, size: fontSize) else {
					throw TKError.fontError(fontName: fontName)
				}
				return font
			} else {
				guard let font = UIFont(name: cgFont.postScriptName! as String, size: fontSize) else {
					throw TKError.fontError(fontName: fontName)
				}
				return font
			}
		} catch let error {
			throw error
		}
	}
	
	public static func color(named colorName: String) -> UIColor? {
		guard let color = UIColor(named: colorName, in: Bundle.module, compatibleWith: nil) else {
			return nil
		}
		return color
	}
	#endif
	
	#if os(macOS)
	public static func loadAllFonts() {
		TKFormula1FontType.allCases.forEach {
			try? NSFont.registerFont(named: $0.rawValue)
		}
	}
	
	public static func image(named imageName: String) throws -> NSImage {
		guard let image = Bundle.module.image(forResource: imageName) else {
			throw TKError.resourceNotFound(resourceName: imageName)
		}
		return image
	}
	
	public static func font(named fontName: String, ofSize fontSize: CGFloat = 12) throws -> NSFont {
		do {
			let fontURL = try resourceURL(named: fontName, ofType: "otf")
			let fontData = try Data(contentsOf: fontURL)
			guard let dataProvider = CGDataProvider(data: fontData as CFData) else {
				throw TKError.fontError(fontName: fontName)
			}
			let cgFont = CGFont(dataProvider)!
			var error: Unmanaged<CFError>?
			if !CTFontManagerRegisterGraphicsFont(cgFont, &error) {
				guard let e: Error = error?.takeRetainedValue(), (e as NSError).code == CTFontManagerError.alreadyRegistered.rawValue, (e as NSError).domain == kCTFontManagerErrorDomain as String, let font = NSFont(name: cgFont.postScriptName! as String, size: fontSize) else {
					throw TKError.fontError(fontName: fontName)
				}
				return font
			} else {
				guard let font = NSFont(name: cgFont.postScriptName! as String, size: fontSize) else {
					throw TKError.fontError(fontName: fontName)
				}
				return font
			}
		} catch let error {
			throw error
		}
	}
	
	public static func color(named colorName: String) -> NSColor? {
		guard let color = NSColor(named: colorName, bundle: Bundle.module) else {
			return nil
		}
		return color
	}
	#endif
	
	public static func resourceURL(named name: String, ofType resourceType: String) throws -> URL {
		guard let resourceURL = Bundle.module.url(forResource: "Other Resources/\(name)", withExtension: resourceType) else {
			throw TKError.resourceNotFound(resourceName: name)
		}
		return resourceURL
	}

}

#if os(iOS)
public extension UIFont {
	
	static func formula1Font(ofType fontType: TKFormula1FontType = .regular, andSize fontSize: CGFloat = 12) -> UIFont? {
		return try? TKResources.font(named: fontType.rawValue, ofSize: fontSize)
	}

	static fileprivate func registerFont(named fontName: String) throws {
		do {
			let fontURL = try TKResources.resourceURL(named: fontName, ofType: "otf")
			let fontData = try Data(contentsOf: fontURL)
			let dataProvider = CGDataProvider(data: fontData as CFData)!
			let fontRef = CGFont(dataProvider)
			var errorRef: Unmanaged<CFError>? = nil

			if (CTFontManagerRegisterGraphicsFont(fontRef!, &errorRef) == false) {
				NSLog("Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
			}
		}
		catch {
			throw TKError.resourceNotFound(resourceName: fontName)
		}
	}

}

public extension UIColor {
	
	static var formula1Red: UIColor? {
		return TKResources.color(named: "F1Red")
	}
	
	static var formula1Black: UIColor? {
		return TKResources.color(named: "F1Black")
	}
	
	static var formula1OffWhite: UIColor? {
		return TKResources.color(named: "F1OffWhite")
	}

	static var formula1LightBlue: UIColor? {
		return TKResources.color(named: "F1LightBlue")
	}
	
	static var random: UIColor {
		return UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 1)
	}
	
}

public extension Color {
	
	static let f1Red = Color(UIColor.formula1Red ?? .red)
	
	static let f1Black = Color(UIColor.formula1Black ?? .black)
	
	static let f1OffWhite = Color(UIColor.formula1OffWhite ?? .white)

	static let f1LightBlue = Color(UIColor.formula1LightBlue ?? .cyan)
	
	static var random = {
		Color(UIColor.random)
	}
	
	static func timingColor(purpleTime: Float32, isPersonnalBestTime: Bool, currentTime: Float32) -> Color {
		return ((currentTime <= purpleTime) && (currentTime > 0)) ? Color(TKResources.color(named: "F1TimingPurple") ?? .purple) : isPersonnalBestTime ? Color(TKResources.color(named: "F1TimingGreen") ?? .green) : Color(TKResources.color(named: "F1TimingWhite") ?? .white)
	}
	
}
#endif

#if os(macOS)
public extension NSFont {
	
	static func formula1Font(ofType fontType: TKFormula1FontType = .regular, andSize fontSize: CGFloat = 12) -> NSFont? {
		return try? TKResources.font(named: fontType.rawValue, ofSize: fontSize)
	}

	static fileprivate func registerFont(named fontName: String) throws {
		do {
			let fontURL = try TKResources.resourceURL(named: fontName, ofType: "otf")
			let fontData = try Data(contentsOf: fontURL)
			let dataProvider = CGDataProvider(data: fontData as CFData)!
			let fontRef = CGFont(dataProvider)
			var errorRef: Unmanaged<CFError>? = nil

			if (CTFontManagerRegisterGraphicsFont(fontRef!, &errorRef) == false) {
				NSLog("Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
			}
		}
		catch {
			throw TKError.resourceNotFound(resourceName: fontName)
		}
	}
	
}

public extension NSColor {
	
	static var formula1Red: NSColor? {
		return TKResources.color(named: "F1Red")
	}
	
	static var formula1Black: NSColor? {
		return TKResources.color(named: "F1Black")
	}
	
	static var formula1OffWhite: NSColor? {
		return TKResources.color(named: "F1OffWhite")
	}
	
	static var formula1LightBlue: NSColor? {
		return TKResources.color(named: "F1LightBlue")
	}

	static var random: NSColor {
		return NSColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 1)
	}
	
}

public extension Color {
	
	static let f1Red = Color(NSColor.formula1Red ?? .red)
	
	static let f1Black = Color(NSColor.formula1Black ?? .black)
	
	static let f1OffWhite = Color(NSColor.formula1OffWhite ?? .white)

	static let f1LightBlue = Color(NSColor.formula1LightBlue ?? .cyan)
	
	static var random = {
		Color(NSColor.random)
	}
	
	static func timingColor(purpleTime: Float32, isPersonnalBestTime: Bool, currentTime: Float32) -> Color {
		return ((currentTime <= purpleTime) && (currentTime > 0)) ? Color(TKResources.color(named: "F1TimingPurple") ?? .purple) : isPersonnalBestTime ? Color(TKResources.color(named: "F1TimingGreen") ?? .green) : Color(TKResources.color(named: "F1TimingWhite") ?? .white)
	}
	
}
#endif

public extension Font {
	
	static func formula1Font(ofType fontType: TKFormula1FontType = .regular, andSize fontSize: CGFloat = 12) -> Font {
		return Font.custom(fontType.rawValue, size: fontSize)
	}
	
}

#if os(iOS)
public extension UIView {
	
	func roundCorners(corners: UIRectCorner, radius: CGFloat) {
		let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
		let mask = CAShapeLayer()
		mask.path = path.cgPath
		layer.mask = mask
	}
	
}
#endif
