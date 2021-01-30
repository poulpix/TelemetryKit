//
//  TKImage.swift
//  TelemetryKit
//
//  Created by 8505305X on 14/07/2020.
//  Copyright © 2020 Poulpix. All rights reserved.
//

import Foundation
import SwiftUI

#if os(iOS)
public struct TKImage: View, UIViewRepresentable {
	
    public var name: String
	fileprivate var imageView: UIImageView = UIImageView()
	fileprivate var originalImage: UIImage!
	
	public init(_ name: String) {
		self.name = name
		self.originalImage = try! TKResources.image(named: name)
		self.imageView.image = originalImage
	}

	public func makeUIView(context: Context) -> UIImageView {
		imageView
    }

	public func updateUIView(_ uiView: UIImageView, context: Context) {
    }
	
	fileprivate func scaledImage(width: CGFloat, height: CGFloat) -> UIImage {
        let size = CGSize(width: width, height: height)
		if (originalImage.size == size) {
            return originalImage
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        originalImage.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
		return image!
    }
    
    public func resize(width: CGFloat, height: CGFloat) -> some View {
        imageView.image = scaledImage(width: width, height: height)
		return frame(width: width, height: height, alignment: .center)
    }
	
}
#endif

#if os(macOS)
public struct TKImage: View, NSViewRepresentable {
	
	public typealias NSViewType = NSImageView
	
	public var name: String
	fileprivate var imageView: NSImageView = NSImageView()
	fileprivate var originalImage: NSImage!
	
	public init(_ name: String) {
		self.name = name
		self.originalImage = try! TKResources.image(named: name)
		self.imageView.image = originalImage
	}

	public func makeNSView(context: Context) -> NSImageView {
		imageView
	}

	public func updateNSView(_ uiView: NSImageView, context: Context) {
	}
	
	fileprivate func scaledImage(width: CGFloat, height: CGFloat) -> NSImage {
		let size = CGSize(width: width, height: height)
		if (originalImage.size == size) {
			return originalImage
		}
		
		let image = NSImage(size: size)
		image.lockFocus()
		image.draw(in: NSMakeRect(0, 0, width, height), from: NSMakeRect(0, 0, originalImage.size.width, originalImage.size.height), operation: .sourceOver, fraction: CGFloat(1))
		image.unlockFocus()
		return image
	}
	
	public func resize(width: CGFloat, height: CGFloat) -> some View {
		imageView.image = scaledImage(width: width, height: height)
		return frame(width: width, height: height, alignment: .center)
	}
	
}
#endif
