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
		HStack {
			Text("\(driver.raceStatus.currentPosition)")
			Rectangle()
				.fill(Color(driver.teamId.color))
				.frame(width: 3, height: 14)
			Text(driver.driverId.trigram)
			Text(driver.raceStatus.bestLapTime.asLapTimeString)
		}
    }
	
}

struct TKDriverCompactView_Previews: PreviewProvider {
	
	@State static var driver = TKParticipantInfo()
	
    static var previews: some View {
		TKGenericPreview(TKDriverCompactView($driver))
	}
	
}
