//
//  TKNumericLabelView.swift
//  TelemetryKit
//
//  Created by Romain on 03/01/2021.
//  Copyright © 2021 Poulpix. All rights reserved.
//

import SwiftUI

public struct TKNumericLabelView<NumericType>: View where NumericType: CustomStringConvertible {
	
	public var label: String
	@Binding public var data: NumericType
	
	public init(_ label: String, data: Binding<NumericType>) {
		self.label = label
		self._data = data
	}
	
	public var body: some View {
		HStack {
			Text(label)
				.font(.formula1Font(ofType: .regular, andSize: 14))
            Text("\(data)" as String)
				.font(.formula1Font(ofType: .bold, andSize: 14))
				.foregroundColor(.f1LightBlue)
		}
        .padding(.bottom, 2)
        .padding(.top, 2)
	}
	
}

#if DEBUG
struct TKNumericLabelView_Previews: PreviewProvider {
	
	static var previews: some View {
		TKGenericPreview(TKNumericLabelView("Label:", data: .constant(1234)))
	}
	
}
#endif
