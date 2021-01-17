//
//  TKTyreCompoundView.swift
//  TelemetryKit
//
//  Created by Romain on 10/01/2021.
//  Copyright © 2021 Poulpix. All rights reserved.
//

import SwiftUI

public struct TKTyreCompoundView: View {
	
	@Binding public var tyreCompound: TKTyreVisualCompound
	
	public init(_ tyreCompound: Binding<TKTyreVisualCompound>) {
		self._tyreCompound = tyreCompound
	}

    public var body: some View {
		ZStack {
			Circle()
				.trim(from: 0.0, to: 0.4)
				.rotation(.degrees(110))
				.stroke(tyreCompound.color, style: StrokeStyle(lineWidth: 3))
				.frame(width: 18, height: 18)
			Text(tyreCompound.abbreviation)
				.font(.formula1Font(ofType: .regular, andSize: 10))
			Circle()
				.trim(from: 0.0, to: 0.4)
				.rotation(.degrees(290))
				.stroke(tyreCompound.color, style: StrokeStyle(lineWidth: 3))
				.frame(width: 18, height: 18)
		}
    }
	
}

struct TKTyreCompoundView_Previews: PreviewProvider {
	
    static var previews: some View {
		Group {
			TKTyreCompoundView(.constant(.f1ModernSoft))
				.environment(\.colorScheme, .light)
			TKTyreCompoundView(.constant(.f1ModernSoft))
				.environment(\.colorScheme, .dark)
		}
    }
	
}
