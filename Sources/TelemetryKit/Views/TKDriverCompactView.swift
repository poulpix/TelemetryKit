//
//  TKDriverCompactView.swift
//  TelemetryKit
//
//  Created by Romain on 03/01/2021.
//  Copyright © 2021 Poulpix. All rights reserved.
//

import SwiftUI

public struct TKDriverCompactView: View {
	
	@Binding public var driver: TKParticipantInfo
	
	public init(_ driver: Binding<TKParticipantInfo>) {
		self._driver = driver
	}
	
    public var body: some View {
		Text("\(driver.raceStatus.currentPosition) – \(driver.driverId.trigram)")
    }
	
}

struct TKDriverCompactView_Previews: PreviewProvider {
	
	@State static var driver = TKParticipantInfo()
	
    static var previews: some View {
		Group {
			TKDriverCompactView($driver)
				.environment(\.colorScheme, .light)
			TKDriverCompactView($driver)
				.environment(\.colorScheme, .dark)
		}
    }
	
}
