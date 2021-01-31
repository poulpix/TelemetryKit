//
//  TKTestObjects.swift
//  TelemetryKit
//
//  Created by Romain on 31/01/2021.
//  Copyright © 2021 Poulpix. All rights reserved.
//

import Foundation

#if DEBUG
public struct TKTestObjects {
	
	static var testSession: TKLiveSessionInfo {
		let session = TKLiveSessionInfo()
		var pRai = TKParticipantInfo()
		pRai.driverId = .kimiRaikkonen
		pRai.teamId = .alfaRomeo
		pRai.raceNumber = 7
		pRai.carStatus = TKCarStatusInfo()
		pRai.carStatus.tyreCompound = .f1ModernSoft
		pRai.raceStatus = TKRaceStatusInfo()
		pRai.raceStatus.currentPosition = 1
		pRai.raceStatus.lastLapTime = 71.153
		pRai.raceStatus.bestLapTime = 71.153
		pRai.raceStatus.currentSector = .sector1
		let raiLap1 = TKLapTime()
		var raiLap2 = TKLapTime()
		raiLap2.sector1Time = 21.612
		raiLap2.sector2Time = 23.098
		raiLap2.sector3Time = 26.443
		raiLap2.lapTime = 71.153
		pRai.raceStatus.lapTimes.append(raiLap1)
		pRai.raceStatus.lapTimes.append(raiLap2)
		pRai.raceStatus.currentLapNo = 3
		session.participants.append(pRai)
		session.liveRankings.append(TKSessionRanking(participant: pRai, driverIndex: 0, gapToLeader: 0))
		var pVer = TKParticipantInfo()
		pVer.driverId = .maxVerstappen
		pVer.teamId = .redBullRacing
		pVer.raceNumber = 33
		pVer.carStatus = TKCarStatusInfo()
		pVer.carStatus.tyreCompound = .f1ModernMedium
		pVer.raceStatus = TKRaceStatusInfo()
		pVer.raceStatus.currentPosition = 2
		pVer.raceStatus.lastLapTime = 71.814
		pVer.raceStatus.bestLapTime = 71.814
		pVer.raceStatus.currentSector = .sector3
		let verLap1 = TKLapTime()
		var verLap2 = TKLapTime()
		verLap2.sector1Time = 21.741
		verLap2.sector2Time = 23.012
		pVer.raceStatus.lapTimes.append(verLap1)
		pVer.raceStatus.lapTimes.append(verLap2)
		pVer.raceStatus.currentLapNo = 2
		session.participants.append(pVer)
		session.liveRankings.append(TKSessionRanking(participant: pVer, driverIndex: 1, gapToLeader: 1.874))
		session.bestS1Time = 21.612
		session.bestS2Time = 23.012
		session.bestS3Time = 26.441
		session.bestLapTime = 71.153
		return session
	}
	
}
#endif
