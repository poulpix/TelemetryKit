//
//  TKDriverLargeView.swift
//  TelemetryKit
//
//  Created by Romain on 10/01/2021.
//  Copyright © 2021 Poulpix. All rights reserved.
//

import SwiftUI

public struct TKDriverLargeView: View {
	
	@Binding public var driver: TKParticipantInfo
	@Binding public var gapToLeader: Float
	
	public init(_ driver: Binding<TKParticipantInfo>, gapToLeader: Binding<Float>) {
		self._driver = driver
		self._gapToLeader = gapToLeader
	}
	
	public var body: some View {
		HStack {
			Group {
				Text("\(driver.raceStatus.currentPosition)")
					.foregroundColor(.f1LightBlue)
				Text("\(driver.raceNumber)")
				Rectangle()
					.fill(Color(driver.teamId.color))
					.frame(width: 3, height: 14)
				Text(driver.driverId.name.uppercased())
			}
			Group {
				Text(driver.raceStatus.bestLapTime.asLapTimeString)
				TKTyreCompoundView($driver.carStatus.tyreCompound)
				Text(gapToLeader.asGapString)
				Text(driver.raceStatus.latestS1Time.asSectorTimeString)
					.foregroundColor(driver.raceStatus.latestS1TimeIsPersonnalBest ? Color(TKResources.color(named: "F1TimingGreen") ?? .green) : Color(TKResources.color(named: "F1TimingWhite") ?? .white))
				Text(driver.raceStatus.latestS2Time.asSectorTimeString)
					.foregroundColor(driver.raceStatus.latestS2TimeIsPersonnalBest ? Color(TKResources.color(named: "F1TimingGreen") ?? .green) : Color(TKResources.color(named: "F1TimingWhite") ?? .white))
				Text(driver.raceStatus.latestS3Time.asSectorTimeString)
					.foregroundColor(driver.raceStatus.latestS3TimeIsPersonnalBest ? Color(TKResources.color(named: "F1TimingGreen") ?? .green) : Color(TKResources.color(named: "F1TimingWhite") ?? .white))
				Text("\(driver.raceStatus.currentLapNo)")
			}
		}
	}
	
}

struct TKDriverLargeView_Previews: PreviewProvider {
	
	@State static var driver = TKParticipantInfo()
	@State static var gapToLeader = Float(3.141)

    static var previews: some View {
		Group {
			TKDriverLargeView($driver, gapToLeader: $gapToLeader)
				.environment(\.colorScheme, .light)
			TKDriverLargeView($driver, gapToLeader: $gapToLeader)
				.environment(\.colorScheme, .dark)
		}
    }
	
}
