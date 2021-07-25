//
//  TKSessionHistoryPacket.swift
//  TelemetryKit
//
//  Created by Romain on 25/07/2021.
//  Copyright © 2021 Poulpix. All rights reserved.
//

import Foundation

internal struct TKSessionHistoryPacket: TKPacket {
    
    static var PACKET_SIZE_F1_2020: Int = 0 // Does not exist in F1 2020
    static var PACKET_SIZE_F1_2021: Int = TKPacketHeader.packetSize(forVersion: .f1_2021) + (21 * TKMarshalZone.packetSize(forVersion: .f1_2021)) + 22 + (20 * TKWeatherForecastSample.packetSize(forVersion: .f1_2021))
    
    var header: TKPacketHeader
    var weather: TKWeather
    var trackTemperature: Int8 // °C
    var airTemperature: Int8 // °C
    var totalLaps: UInt8
    var trackLength: UInt16 // meters
    var sessionType: TKSessionType
    var trackId: TKTrack
    var formula: TKFormula
    var sessionTimeLeft: UInt16 // sec
    var sessionDuration: UInt16 // sec
    var pitSpeedLimit: UInt8 // km/h
    var gamePaused: TKBool
    var isSpectating: TKBool
    var spectatorCarIndex: UInt8
    var sliProNativeSupport: TKBool
    var numMarshalZones: UInt8
    var marshalZones: [TKMarshalZone] // 21
    var safetyCarStatus: TKSafetyCarStatus
    var networkGame: TKBool
    var numWeatherForecastSamples: UInt8
    var weatherForecastSamples: [TKWeatherForecastSample] // 20
    
    var computedMarshalZones: [TKMarshalZone] {
        return Array(marshalZones.prefix(Int(numMarshalZones)))
    }
    
    init() {
        header = TKPacketHeader()
        weather = .clear
        trackTemperature = 0
        airTemperature = 0
        totalLaps = 0
        trackLength = 0
        sessionType = .unknown
        trackId = .melbourne
        formula = .f1modern
        sessionTimeLeft = 0
        sessionDuration = 0
        pitSpeedLimit = 0
        gamePaused = .no
        isSpectating = .no
        spectatorCarIndex = 0
        sliProNativeSupport = .no
        numMarshalZones = 0
        marshalZones = [TKMarshalZone]()
        safetyCarStatus = .noSafetyCar
        networkGame = .no
        numWeatherForecastSamples = 0
        weatherForecastSamples = [TKWeatherForecastSample]()
    }
    
    mutating func build(fromRawData data: Data, at offset: Int, forVersion version: TKF1Version) {
        header = TKPacketHeader.build(fromRawData: data, forVersion: version)
        weather = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 0)
        trackTemperature = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 1)
        airTemperature = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 2)
        totalLaps = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 3)
        trackLength = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 4)
        sessionType = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 6)
        trackId = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 7)
        formula = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 8)
        sessionTimeLeft = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 9)
        sessionDuration = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 11)
        pitSpeedLimit = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 13)
        gamePaused = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 14)
        isSpectating = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 15)
        spectatorCarIndex = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 16)
        sliProNativeSupport = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 17)
        numMarshalZones = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 18)
        marshalZones = type(of: self).buildArray(ofSize: 21, fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 19, forVersion: version)
        safetyCarStatus = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 19 + 21 * TKMarshalZone.packetSize(forVersion: version))
        let tmpNetworkGame: TKBool = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 20 + 21 * TKMarshalZone.packetSize(forVersion: version))
        networkGame = tmpNetworkGame.opposite
        numWeatherForecastSamples = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 21 + 21 * TKMarshalZone.packetSize(forVersion: version))
        weatherForecastSamples = type(of: self).buildArray(ofSize: 20, fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 22 + 21 * TKMarshalZone.packetSize(forVersion: version), forVersion: version)
    }
    
    func process(withDelegate delegate: TKDelegate) {
        //delegate.update(sessionInfo: self)
    }

}

extension TKSessionHistoryPacket: CustomStringConvertible {
    
    var description: String {
        var lines = [String]()
        lines.append(header.description)
        lines.append("\tWeather: \(weather), track temperature: \(trackTemperature), air temperature: \(airTemperature), total laps: \(totalLaps), session type: \(sessionType), track: \(trackId), formula: \(formula), session time left: \(sessionTimeLeft), session duration: \(sessionDuration), safety car status: \(safetyCarStatus)")
        for (index, mz) in marshalZones.enumerated() {
            if index < numMarshalZones {
                lines.append("\t\tMarshal zone \(index + 1): \(mz.description)")
            }
        }
        for (index, wfs) in weatherForecastSamples.enumerated() {
            if index < numWeatherForecastSamples {
                lines.append("\t\t\(wfs.description)")
            }
        }
        return lines.joined(separator: "\n")
    }
    
}
