//
//  TKGenericPreview.swift
//  TelemetryKit
//
//  Created by Romain on 30/01/2021.
//  Copyright © 2021 Poulpix. All rights reserved.
//

import SwiftUI

#if DEBUG
public struct TKGenericPreview<V: View>: View {

	private let viewToPreview: V

	public init(_ viewToPreview: V) {
		self.viewToPreview = viewToPreview
	}

	public var body: some View {
		Group {
			self.viewToPreview
				.previewDevice("iPhone 12 Pro")
				.preferredColorScheme(.light)
				.previewDisplayName("iPhone 12 Pro – Light")
			self.viewToPreview
				.previewDevice("iPhone 12 Pro")
				.preferredColorScheme(.dark)
				.previewDisplayName("iPhone 12 Pro – Dark")
			self.viewToPreview
				.previewDevice("iPad Pro (11-inch) (2nd generation)")
				.preferredColorScheme(.light)
				.previewDisplayName("iPad Pro 11\" – Light")
			self.viewToPreview
				.previewDevice("iPad Pro (11-inch) (2nd generation)")
				.preferredColorScheme(.dark)
				.previewDisplayName("iPad Pro 11\" – Dark")
			self.viewToPreview
				.previewDevice("Mac Catalyst")
				.preferredColorScheme(.light)
				.previewDisplayName("Mac Catalyst – Light")
			self.viewToPreview
				.previewDevice("Mac Catalyst")
				.preferredColorScheme(.dark)
				.previewDisplayName("Mac Catalyst – Dark")
		}
	}
	
}
#endif
