//
//  TKLiveRankingsRaceView.swift
//  TelemetryKit
//
//  Created by Romain on 12/01/2021.
//  Copyright © 2021 Poulpix. All rights reserved.
//

import SwiftUI

public struct TKLiveRankingsRaceView: View {
    
    @Binding public var liveSessionInfo: TKLiveSessionInfo
    
    public init(_ liveSessionInfo: Binding<TKLiveSessionInfo>) {
        self._liveSessionInfo = liveSessionInfo
    }
    
    public var body: some View {
        ScrollView(.vertical) {
            GeometryReader { geometry in
                LazyVGrid(columns: columns(forWidth: geometry.size.width), alignment: .trailing, spacing: 10) {
                    // Header
                    Group {
                        Text("P")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        Group {
                            if TKScreenEstateStyle.screenEstate(forWidth: geometry.size.width) != .small {
                                Text("NO")
                            }
                            Text("")
                            Text("DRIVER")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        if TKScreenEstateStyle.screenEstate(forWidth: geometry.size.width) == .large {
                            Text("BEST")
                        }
                        Text("LAST")
                        Text("TY")
                        if TKScreenEstateStyle.screenEstate(forWidth: geometry.size.width) != .small {
                            Group {
                                Text("S1")
                                Text("S2")
                                Text("S3")
                            }
                        }
                        Text("LAP")
                    }
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.formula1Font(ofType: .regular, andSize: 12))
                    // Classification
                    ForEach(liveSessionInfo.liveRankings.indices, id: \.self) { idx in
                        Text("\(liveSessionInfo.participant(at: idx).raceStatus.currentPosition)")
                            .foregroundColor(.f1LightBlue)
                        Group {
                            if TKScreenEstateStyle.screenEstate(forWidth: geometry.size.width) != .small {
                                Text("\(liveSessionInfo.participant(at: idx).raceNumber)")
                            }
                            Rectangle()
                                .fill(Color(liveSessionInfo.participant(at: idx).teamId.color))
                                .frame(width: 3, height: 14)
                            Text((TKScreenEstateStyle.screenEstate(forWidth: geometry.size.width) == .large) ? liveSessionInfo.participant(at: idx).driverId.name.uppercased() : liveSessionInfo.participant(at: idx).driverId.trigram.uppercased())
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        if TKScreenEstateStyle.screenEstate(forWidth: geometry.size.width) == .large {
                            Text(liveSessionInfo.participant(at: idx).raceStatus.bestLapTime.asLapTimeString)
                                .foregroundColor(.timingColor(purpleTime: liveSessionInfo.bestLapTime, isPersonnalBestTime: true, currentTime: liveSessionInfo.participant(at: idx).raceStatus.bestLapTime))
                        }
                        Text(liveSessionInfo.participant(at: idx).raceStatus.lastLapTime.asLapTimeString)
                            .foregroundColor(.timingColor(purpleTime: liveSessionInfo.bestLapTime, isPersonnalBestTime: liveSessionInfo.participant(at: idx).raceStatus.lastLapTimeIsPersonnalBest, currentTime: liveSessionInfo.participant(at: idx).raceStatus.lastLapTime))
                        TKTyreCompoundView($liveSessionInfo.participants[liveSessionInfo.liveRankings[idx].driverIndex].carStatus.tyreCompound)
                        if TKScreenEstateStyle.screenEstate(forWidth: geometry.size.width) != .small {
                            Group {
                                Text(liveSessionInfo.participant(at: idx).raceStatus.latestS1Time.asSectorTimeString)
                                    .foregroundColor(.timingColor(purpleTime: liveSessionInfo.bestS1Time, isPersonnalBestTime: liveSessionInfo.participant(at: idx).raceStatus.latestS1TimeIsPersonnalBest, currentTime: liveSessionInfo.participant(at: idx).raceStatus.latestS1Time))
                                Text(liveSessionInfo.participant(at: idx).raceStatus.latestS2Time.asSectorTimeString)
                                    .foregroundColor(.timingColor(purpleTime: liveSessionInfo.bestS2Time, isPersonnalBestTime: liveSessionInfo.participant(at: idx).raceStatus.latestS2TimeIsPersonnalBest, currentTime: liveSessionInfo.participant(at: idx).raceStatus.latestS2Time))
                                Text(liveSessionInfo.participant(at: idx).raceStatus.latestS3Time.asSectorTimeString)
                                    .foregroundColor(.timingColor(purpleTime: liveSessionInfo.bestS3Time, isPersonnalBestTime: liveSessionInfo.participant(at: idx).raceStatus.latestS3TimeIsPersonnalBest, currentTime: liveSessionInfo.participant(at: idx).raceStatus.latestS3Time))
                            }
                        }
                        Text("\(liveSessionInfo.participant(at: idx).raceStatus.currentLapNo)")
                            .padding(.trailing, 20)
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
            }
        }
        .font(.formula1Font(ofType: .regular, andSize: 14))
    }
    
    private func columns(forWidth width: CGFloat) -> [GridItem] {
        switch TKScreenEstateStyle.screenEstate(forWidth: width) {
        case .small:
            return [
                GridItem(.fixed(30)), // Position
                GridItem(.fixed(3)), // Team badge
                GridItem(.flexible(minimum: 50)), // Driver trigram
                GridItem(.fixed(100)), // Last lap time
                GridItem(.fixed(30)), // Tyre compound
                GridItem(.fixed(50)) // Lap number
            ]
        case .medium:
            return [
                GridItem(.fixed(30)), // Position
                GridItem(.fixed(26)), // Driver number
                GridItem(.fixed(3)), // Team badge
                GridItem(.flexible(minimum: 150)), // Driver trigram
                GridItem(.fixed(100)), // Last lap time
                GridItem(.fixed(30)), // Tyre compound
                GridItem(.fixed(90)), // Last sector 1 time
                GridItem(.fixed(90)), // Last sector 2 time
                GridItem(.fixed(90)), // Last sector 3 time
                GridItem(.fixed(50)) // Lap number
            ]
        case .large:
            return [
                GridItem(.fixed(30)), // Position
                GridItem(.fixed(26)), // Driver number
                GridItem(.fixed(3)), // Team badge
                GridItem(.flexible(minimum: 150)), // Driver name
                GridItem(.fixed(100)), // Best lap time
                GridItem(.fixed(100)), // Last lap time
                GridItem(.fixed(30)), // Tyre compound
                GridItem(.fixed(90)), // Last sector 1 time
                GridItem(.fixed(90)), // Last sector 2 time
                GridItem(.fixed(90)), // Last sector 3 time
                GridItem(.fixed(50)) // Lap number
            ]
        }
    }
    
}

#if DEBUG
struct TKLiveRankingsRaceView_Previews: PreviewProvider {
    
    @State static var liveSessionInfo = TKTestObjects.testSession
    
    static var previews: some View {
        TKGenericPreview(TKLiveRankingsRaceView($liveSessionInfo))
    }
    
}
#endif
