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
    @Binding public var fastestS1: Float32
    @Binding public var fastestS2: Float32
    @Binding public var fastestS3: Float32
    @Binding public var fastestLap: Float32
	@Binding public var gapToLeader: Float32
	
    public init(_ driver: Binding<TKParticipantInfo>, fastestS1: Binding<Float32>, fastestS2: Binding<Float32>, fastestS3: Binding<Float32>, fastestLap: Binding<Float32>, gapToLeader: Binding<Float32>) {
		self._driver = driver
        self._fastestS1 = fastestS1
        self._fastestS2 = fastestS2
        self._fastestS3 = fastestS3
        self._fastestLap = fastestLap
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
				Text(driver.raceStatus.lastLapTime.asLapTimeString)
                    .foregroundColor((driver.raceStatus.lastLapTime <= fastestLap) ? Color(TKResources.color(named: "F1TimingPurple") ?? .purple) : driver.raceStatus.lastLapTimeIsPersonnalBest ? Color(TKResources.color(named: "F1TimingGreen") ?? .green) : Color(TKResources.color(named: "F1TimingWhite") ?? .white))
				TKTyreCompoundView($driver.carStatus.tyreCompound)
				Text(driver.raceStatus.latestS1Time.asSectorTimeString)
					.foregroundColor((driver.raceStatus.latestS1Time <= fastestS1) ? Color(TKResources.color(named: "F1TimingPurple") ?? .purple) : driver.raceStatus.latestS1TimeIsPersonnalBest ? Color(TKResources.color(named: "F1TimingGreen") ?? .green) : Color(TKResources.color(named: "F1TimingWhite") ?? .white))
				Text(driver.raceStatus.latestS2Time.asSectorTimeString)
					.foregroundColor((driver.raceStatus.latestS2Time <= fastestS2) ? Color(TKResources.color(named: "F1TimingPurple") ?? .purple) : driver.raceStatus.latestS2TimeIsPersonnalBest ? Color(TKResources.color(named: "F1TimingGreen") ?? .green) : Color(TKResources.color(named: "F1TimingWhite") ?? .white))
				Text(driver.raceStatus.latestS3Time.asSectorTimeString)
					.foregroundColor((driver.raceStatus.latestS3Time <= fastestS3) ? Color(TKResources.color(named: "F1TimingPurple") ?? .purple) : driver.raceStatus.latestS3TimeIsPersonnalBest ? Color(TKResources.color(named: "F1TimingGreen") ?? .green) : Color(TKResources.color(named: "F1TimingWhite") ?? .white))
				Text("\(driver.raceStatus.currentLapNo)")
			}
		}
	}
	
}

struct TKDriverLargeView_Previews: PreviewProvider {
	
	@State static var driver = TKParticipantInfo()
    @State static var fastestS1 = Float32(10.123)
    @State static var fastestS2 = Float32(20.456)
    @State static var fastestS3 = Float32(30.789)
    @State static var fastestLap = Float32(61.368)
	@State static var gapToLeader = Float32(3.141)

    static var previews: some View {
		Group {
            TKDriverLargeView($driver, fastestS1: $fastestS1, fastestS2: $fastestS2, fastestS3: $fastestS3, fastestLap: $fastestLap, gapToLeader: $gapToLeader)
				.environment(\.colorScheme, .light)
			TKDriverLargeView($driver, fastestS1: $fastestS1, fastestS2: $fastestS2, fastestS3: $fastestS3, fastestLap: $fastestLap, gapToLeader: $gapToLeader)
				.environment(\.colorScheme, .dark)
		}
    }
	
}
