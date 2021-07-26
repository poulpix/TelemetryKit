//
//  TKSessionHistoryPacket.swift
//  TelemetryKit
//
//  Created by Romain on 25/07/2021.
//  Copyright © 2021 Poulpix. All rights reserved.
//

import Foundation

internal struct TKLapHistoryData: TKPacket {
    
    static var PACKET_SIZE_F1_2020: Int = 0 // Does not exist in F1 2020
    static var PACKET_SIZE_F1_2021: Int = 11
    
    var lapTimeInMS: UInt32 // ms – New in F1 2021
    var sector1TimeInMS: UInt16 // ms – New in F1 2021
    var sector2TimeInMS: UInt16 // ms – New in F1 2021
    var sector3TimeInMS: UInt16 // ms – New in F1 2021
    var lapValidFlags: UInt8 // 0x01 bit set == lap valid, 0x02 bit set == sector 1 valid, 0x04 bit set == sector 2 valid, 0x08 bit set == sector 3 valid – New in F1 2021
    
    var lapValid: Bool {
        return (lapValidFlags & 0x01) == 0x01
    }

    var sector1Valid: Bool {
        return (lapValidFlags & 0x02) == 0x02
    }

    var sector2Valid: Bool {
        return (lapValidFlags & 0x04) == 0x04
    }

    var sector3Valid: Bool {
        return (lapValidFlags & 0x08) == 0x08
    }
    
    init() {
        lapTimeInMS = 0
        sector1TimeInMS = 0
        sector2TimeInMS = 0
        sector3TimeInMS = 0
        lapValidFlags = 0
    }
    
    mutating func build(fromRawData data: Data, at offset: Int, forVersion version: TKF1Version) {
        switch version {
        case .unknown:
            return
        case .f1_2020:
            return
        case .f1_2021:
            lapTimeInMS = type(of: self).read(fromRawData: data, at: offset + 0)
            sector1TimeInMS = type(of: self).read(fromRawData: data, at: offset + 4)
            sector2TimeInMS = type(of: self).read(fromRawData: data, at: offset + 6)
            sector3TimeInMS = type(of: self).read(fromRawData: data, at: offset + 8)
            lapValidFlags = type(of: self).read(fromRawData: data, at: offset + 10)
        }
    }

}

extension TKLapHistoryData: CustomStringConvertible {
    
    var description: String {
        return "lap time = \(lapTimeInMS.asLapTimeString), S1 = \(sector1TimeInMS.asSectorTimeString), S2 = \(sector2TimeInMS.asSectorTimeString), S3 = \(sector3TimeInMS.asSectorTimeString), lap valid = \(lapValid)"
    }
    
}

internal struct TKTyreStintHistoryData: TKPacket {
    
    static var PACKET_SIZE_F1_2020: Int = 0 // Does not exist in F1 2020
    static var PACKET_SIZE_F1_2021: Int = 3
    
    var endLap: UInt8 // New in F1 2021
    var tyreActualCompound: TKTyreCompound // New in F1 2021
    var tyreVisualCompound: TKTyreVisualCompound // New in F1 2021
    
    init() {
        endLap = 0
        tyreActualCompound = .unknown
        tyreVisualCompound = .unknown
    }
    
    mutating func build(fromRawData data: Data, at offset: Int, forVersion version: TKF1Version) {
        switch version {
        case .unknown:
            return
        case .f1_2020:
            return
        case .f1_2021:
            endLap = type(of: self).read(fromRawData: data, at: offset + 0)
            tyreActualCompound = type(of: self).readEnum(fromRawData: data, at: offset + 1)
            tyreVisualCompound = type(of: self).readEnum(fromRawData: data, at: offset + 2)
        }
    }
    
}

extension TKTyreStintHistoryData: CustomStringConvertible {
    
    var description: String {
        return "tyre \(tyreVisualCompound) (\(tyreActualCompound)) left on lap \(endLap)"
    }
    
}

internal struct TKSessionHistoryPacket: TKPacket {
    
    static var PACKET_SIZE_F1_2020: Int = 0 // Does not exist in F1 2020
    static var PACKET_SIZE_F1_2021: Int = TKPacketHeader.packetSize(forVersion: .f1_2021) + 7 +  (100 * TKLapHistoryData.packetSize(forVersion: .f1_2021)) + (8 * TKTyreStintHistoryData.packetSize(forVersion: .f1_2021))
    
    var header: TKPacketHeader
    var carIndex: UInt8 // New in F1 2021
    var numLaps: UInt8 // New in F1 2021
    var numTyreStints: UInt8 // New in F1 2021
    var bestLapTimeLapNum: UInt8 // New in F1 2021
    var bestSector1LapNum: UInt8 // New in F1 2021
    var bestSector2LapNum: UInt8 // New in F1 2021
    var bestSector3LapNum: UInt8 // New in F1 2021
    var lapHistoryData: [TKLapHistoryData] // 100 – New in F1 2021
    var tyreStintsHistoryData: [TKTyreStintHistoryData] // 8 – New in F1 2021
    
    var computedLapHistory: [TKLapHistoryData] {
        return Array(lapHistoryData.prefix(Int(numLaps)))
    }
    
    var computedTyreStintsHistory: [TKTyreStintHistoryData] {
        return Array(tyreStintsHistoryData.prefix(Int(numTyreStints)))
    }
    
    init() {
        header = TKPacketHeader()
        carIndex = 0
        numLaps = 0
        numTyreStints = 0
        bestLapTimeLapNum = 0
        bestSector1LapNum = 0
        bestSector2LapNum = 0
        bestSector3LapNum = 0
        lapHistoryData = [TKLapHistoryData]()
        tyreStintsHistoryData = [TKTyreStintHistoryData]()
    }
    
    mutating func build(fromRawData data: Data, at offset: Int, forVersion version: TKF1Version) {
        switch version {
        case .unknown:
            return
        case .f1_2020:
            return
        case .f1_2021:
            header = TKPacketHeader.build(fromRawData: data, forVersion: version)
            carIndex = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 0)
            numLaps = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 1)
            numTyreStints = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 2)
            bestLapTimeLapNum = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 3)
            bestSector1LapNum = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 4)
            bestSector2LapNum = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 5)
            bestSector3LapNum = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 6)
            lapHistoryData = type(of: self).buildArray(ofSize: 100, fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 7, forVersion: version)
            tyreStintsHistoryData = type(of: self).buildArray(ofSize: 8, fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 7 + 100 * TKLapHistoryData.packetSize(forVersion: version), forVersion: version)
        }
    }
    
    func process(withDelegate delegate: TKDelegate) {
        delegate.update(sessionHistory: self, forDriverNo: carIndex)
    }

}

extension TKSessionHistoryPacket: CustomStringConvertible {
    
    var description: String {
        var lines = [String]()
        lines.append(header.description)
        lines.append("\tCar no: \(carIndex), best lap time lap no: \(bestLapTimeLapNum), best S1 time lap no: \(bestSector1LapNum), best S2 time lap no: \(bestSector2LapNum), best S3 time lap no: \(bestSector3LapNum)")
        for (index, ld) in lapHistoryData.enumerated() {
            if index < numLaps {
                lines.append("\t\tLap \(index + 1): \(ld.description)")
            }
        }
        for (index, tsh) in tyreStintsHistoryData.enumerated() {
            if index < numTyreStints {
                lines.append("\t\t\(tsh.description)")
            }
        }
        return lines.joined(separator: "\n")
    }
    
}
