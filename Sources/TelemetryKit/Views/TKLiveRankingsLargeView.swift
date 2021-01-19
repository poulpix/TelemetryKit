//
//  TKLiveRankingsLargeView.swift
//  TelemetryKit
//
//  Created by Romain on 12/01/2021.
//  Copyright © 2021 Poulpix. All rights reserved.
//

import SwiftUI

public struct TKLiveRankingsLargeView: View {
	
	@Binding public var liveSessionInfo: TKLiveSessionInfo
	private var columns: [GridItem] = [
		GridItem(.fixed(30)),
		GridItem(.fixed(25)),
		GridItem(.fixed(3)),
		GridItem(.flexible(minimum: 150)),
		GridItem(.fixed(100)),
		GridItem(.fixed(30)),
		GridItem(.fixed(90)),
		GridItem(.fixed(90)),
		GridItem(.fixed(90)),
		GridItem(.fixed(50))
	]
	
	public init(_ liveSessionInfo: Binding<TKLiveSessionInfo>) {
		self._liveSessionInfo = liveSessionInfo
	}

    public var body: some View {
		LazyVGrid(columns: columns, alignment: .trailing, spacing: 16) {
			ForEach(liveSessionInfo.liveRankings.indices, id: \.self) { idx in
				Text("\(liveSessionInfo.participant(at: idx).raceStatus.currentPosition)")
					.foregroundColor(.f1LightBlue)
				Group {
					Text("\(liveSessionInfo.participant(at: idx).raceNumber)")
					Rectangle()
						.fill(Color(liveSessionInfo.participant(at: idx).teamId.color))
						.frame(width: 3, height: 14)
					Text(liveSessionInfo.participant(at: idx).driverId.name.uppercased())
						.frame(maxWidth: .infinity, alignment: .leading)
				}
				Text(liveSessionInfo.participant(at: idx).raceStatus.lastLapTime.asLapTimeString)
					.foregroundColor(.timingColor(purpleTime: liveSessionInfo.bestLapTime, isPersonnalBestTime: liveSessionInfo.participant(at: idx).raceStatus.lastLapTimeIsPersonnalBest, currentTime: liveSessionInfo.participant(at: idx).raceStatus.lastLapTime))
				TKTyreCompoundView($liveSessionInfo.participants[liveSessionInfo.liveRankings[idx].driverIndex].carStatus.tyreCompound)
				Group {
					Text(liveSessionInfo.participant(at: idx).raceStatus.latestS1Time.asSectorTimeString)
						.foregroundColor(.timingColor(purpleTime: liveSessionInfo.bestS1Time, isPersonnalBestTime: liveSessionInfo.participant(at: idx).raceStatus.latestS1TimeIsPersonnalBest, currentTime: liveSessionInfo.participant(at: idx).raceStatus.latestS1Time))
					Text(liveSessionInfo.participant(at: idx).raceStatus.latestS2Time.asSectorTimeString)
						.foregroundColor(.timingColor(purpleTime: liveSessionInfo.bestS2Time, isPersonnalBestTime: liveSessionInfo.participant(at: idx).raceStatus.latestS2TimeIsPersonnalBest, currentTime: liveSessionInfo.participant(at: idx).raceStatus.latestS2Time))
					Text(liveSessionInfo.participant(at: idx).raceStatus.latestS3Time.asSectorTimeString)
						.foregroundColor(.timingColor(purpleTime: liveSessionInfo.bestS3Time, isPersonnalBestTime: liveSessionInfo.participant(at: idx).raceStatus.latestS3TimeIsPersonnalBest, currentTime: liveSessionInfo.participant(at: idx).raceStatus.latestS3Time))
				}
				Text("\(liveSessionInfo.participant(at: idx).raceStatus.currentLapNo)")
					.padding(.trailing, 20)
			}
		}
    }
	
}

struct TKLiveRankingsLargeView_Previews: PreviewProvider {
	
	@State static var liveSessionInfo = TKLiveSessionInfo()

    static var previews: some View {
		TKLiveRankingsLargeView($liveSessionInfo)
    }
	
}
