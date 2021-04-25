//
//  TKTextLabelView.swift
//  TelemetryKit
//
//  Created by Romain on 03/01/2021.
//  Copyright © 2021 Poulpix. All rights reserved.
//

import SwiftUI

public struct TKTextLabelView: View {
	
	public var label: String
	public var dataFormat: String
	@Binding public var data: String
	
	public init(_ label: String, dataFormat: String = "%@", data: Binding<String>) {
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
        .padding(.bottom, 2)
        .padding(.top, 2)
	}
	
}

#if DEBUG
struct TKTextLabelView_Previews: PreviewProvider {
	
	static var previews: some View {
		TKGenericPreview(TKTextLabelView("Label:", dataFormat: "%@", data: .constant("test")))
	}
	
}
#endif
