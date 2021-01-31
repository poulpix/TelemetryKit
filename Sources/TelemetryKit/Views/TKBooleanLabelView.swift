//
//  TKTelemetryBooleanLabelView.swift
//  TelemetryKit
//
//  Created by Romain on 03/01/2021.
//  Copyright © 2021 Poulpix. All rights reserved.
//

import SwiftUI

public struct TKBooleanLabelView: View {
	
	public var label: String
	@Binding public var data: Bool
	
	public init(_ label: String, data: Binding<Bool>) {
		self.label = label
		self._data = data
	}
		
	public var body: some View {
		HStack {
			Text(label)
				.font(.formula1Font(ofType: .regular, andSize: 14))
			Text(TKBool.from(data).asString)
				.font(.formula1Font(ofType: .bold, andSize: 14))
				.foregroundColor(.f1LightBlue)
		}
	}
	
}

#if DEBUG
struct TKBooleanLabelView_Previews: PreviewProvider {
	
	static var previews: some View {
		TKGenericPreview(TKBooleanLabelView("Label:", data: .constant(true)))
	}
	
}
#endif
