//
//  SwiftUIView.swift
//  TelemetryKit
//
//  Created by Romain on 03/01/2021.
//  Copyright © 2021 Poulpix. All rights reserved.
//

import SwiftUI

public struct TKUInt8LabelView: View {
	
	public var label: String
	public var dataFormat: String = "%d"
	@Binding public var data: UInt8
	
	public init(_ label: String, dataFormat: String = "%d", data: Binding<UInt8>) {
		self.label = label
		self.dataFormat = dataFormat
		self._data = data
	}
	
	public var body: some View {
		HStack {
			Text(label)
				.font(.formula1Font(ofType: .regular, andSize: 14))
			Text(String(format: dataFormat, data))
				.font(.formula1Font(ofType: .bold, andSize: 14))
				.foregroundColor(.f1LightBlue)
		}
	}
	
}

#if DEBUG
struct TKUInt8LabelView_Previews: PreviewProvider {
	
	static var previews: some View {
		TKGenericPreview(TKUInt8LabelView("Label:", data: .constant(123)))
	}
	
}
#endif
