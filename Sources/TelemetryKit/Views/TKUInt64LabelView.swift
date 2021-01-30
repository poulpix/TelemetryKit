//
//  SwiftUIView.swift
//  TelemetryKit
//
//  Created by Romain on 03/01/2021.
//  Copyright © 2021 Poulpix. All rights reserved.
//

import SwiftUI

public struct TKUInt64LabelView: View {
	
	public var label: String
	public var dataFormat: String = "%d"
	@Binding public var data: UInt64
	
	public init(_ label: String, dataFormat: String = "%d", data: Binding<UInt64>) {
		self.label = label
		self.dataFormat = dataFormat
		self._data = data
	}
	
	public var body: some View {
		HStack {
			Text(label)
			Text(String(format: dataFormat, data))
				.font(.formula1Font(ofType: .bold, andSize: 14))
				.foregroundColor(.f1LightBlue)
		}
	}
	
}

struct TKUInt64LabelView_Previews: PreviewProvider {
	
	static var previews: some View {
		TKGenericPreview(TKUInt64LabelView("Label:", data: .constant(1234)))
	}
	
}
