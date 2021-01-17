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
	
	public init(_ liveSessionInfo: Binding<TKLiveSessionInfo>) {
		self._liveSessionInfo = liveSessionInfo
	}

    public var body: some View {
		ForEach(liveSessionInfo.liveRankings.indices, id: \.self) { idx in
            TKDriverLargeView($liveSessionInfo.participants[liveSessionInfo.liveRankings[idx].driverIndex], fastestS1: $liveSessionInfo.bestS1Time, fastestS2: $liveSessionInfo.bestS2Time, fastestS3: $liveSessionInfo.bestS3Time, fastestLap: $liveSessionInfo.bestLapTime, gapToLeader: $liveSessionInfo.liveRankings[idx].gapToLeader)
		}
    }
	
}

struct TKLiveRankingsLargeView_Previews: PreviewProvider {
	
	@State static var liveSessionInfo = TKLiveSessionInfo()

    static var previews: some View {
		TKLiveRankingsLargeView($liveSessionInfo)
    }
	
}
