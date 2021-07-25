//
//  TKCarDamagePacket.swift
//  TelemetryKit
//
//  Created by Romain on 25/07/2021.
//  Copyright © 2021 Poulpix. All rights reserved.
//

import Foundation

internal struct TKCarDamageData: TKPacket {
    
    static let PACKET_SIZE_F1_2020: Int = 0 // Does not exist in F1 2020
    static let PACKET_SIZE_F1_2021: Int = 39
    
    var tyresWear: [Float32] // 4 // percentage – New in F1 2021
    var tyresDamage: [UInt8] // 4 // percentage – New in F1 2021
    var brakesDamage: [UInt8] // 4 // percentage – New in F1 2021
    var frontLeftWingDamage: UInt8 // percentage – New in F1 2021
    var frontRightWingDamage: UInt8 // percentage – New in F1 2021
    var rearWingDamage: UInt8 // percentage – New in F1 2021
    var floorDamage: UInt8 // percentage – New in F1 2021
    var diffuserDamage: UInt8 // percentage – New in F1 2021
    var sidepodDamage: UInt8 // percentage – New in F1 2021
    var drsFault: TKBool // New in F1 2021
    var gearBoxDamage: UInt8 // percentage – New in F1 2021
    var engineDamage: UInt8 // percentage – New in F1 2021
    var engineMGUHWear: UInt8 // percentage – New in F1 2021
    var engineESWear: UInt8 // percentage – New in F1 2021
    var engineCEWear: UInt8 // percentage – New in F1 2021
    var engineICEWear: UInt8 // percentage – New in F1 2021
    var engineMGUKWear: UInt8 // percentage – New in F1 2021
    var engineTCWear: UInt8 // percentage – New in F1 2021
    
    init() {
        tyresWear = [Float32]()
        tyresDamage = [UInt8]()
        brakesDamage = [UInt8]()
        frontLeftWingDamage = 0
        frontRightWingDamage = 0
        rearWingDamage = 0
        floorDamage = 0
        diffuserDamage = 0
        sidepodDamage = 0
        drsFault = .no
        gearBoxDamage = 0
        engineDamage = 0
        engineMGUHWear = 0
        engineESWear = 0
        engineCEWear = 0
        engineICEWear = 0
        engineMGUKWear = 0
        engineTCWear = 0
    }
    
    mutating func build(fromRawData data: Data, at offset: Int, forVersion version: TKF1Version) {
        switch version {
        case .unknown:
            return
        case .f1_2020:
            return
        case .f1_2021:
            tyresWear = type(of: self).readArray(ofSize: 4, fromRawData: data, at: offset + 0)
            tyresDamage = type(of: self).readArray(ofSize: 4, fromRawData: data, at: offset + 16)
            brakesDamage = type(of: self).readArray(ofSize: 4, fromRawData: data, at: offset + 20)
            frontLeftWingDamage = type(of: self).read(fromRawData: data, at: offset + 24)
            frontRightWingDamage = type(of: self).read(fromRawData: data, at: offset + 25)
            rearWingDamage = type(of: self).read(fromRawData: data, at: offset + 26)
            floorDamage = type(of: self).read(fromRawData: data, at: offset + 27)
            diffuserDamage = type(of: self).read(fromRawData: data, at: offset + 28)
            sidepodDamage = type(of: self).read(fromRawData: data, at: offset + 29)
            drsFault = type(of: self).readEnum(fromRawData: data, at: offset + 30)
            gearBoxDamage = type(of: self).read(fromRawData: data, at: offset + 31)
            engineDamage = type(of: self).read(fromRawData: data, at: offset + 32)
            engineMGUHWear = type(of: self).read(fromRawData: data, at: offset + 33)
            engineESWear = type(of: self).read(fromRawData: data, at: offset + 34)
            engineCEWear = type(of: self).read(fromRawData: data, at: offset + 35)
            engineICEWear = type(of: self).read(fromRawData: data, at: offset + 36)
            engineMGUKWear = type(of: self).read(fromRawData: data, at: offset + 37)
            engineTCWear = type(of: self).read(fromRawData: data, at: offset + 38)
        }
    }
    
}

extension TKCarDamageData: CustomStringConvertible {
    
    var description: String {
        return "tyres wear \(tyresWear[0])-\(tyresWear[1])-\(tyresWear[2])-\(tyresWear[3]), tyres damage \(tyresDamage[0])-\(tyresDamage[1])-\(tyresDamage[2])-\(tyresDamage[3]), brakes damage \(brakesDamage[0])-\(brakesDamage[1])-\(brakesDamage[2])-\(brakesDamage[3]), wings damage \(frontLeftWingDamage)-\(frontRightWingDamage)-\(rearWingDamage), chassis damage \(floorDamage)-\(diffuserDamage)-\(sidepodDamage), DRS fault \(drsFault), gearbox damage \(gearBoxDamage), engine damage \(engineDamage)-\(engineMGUHWear)-\(engineESWear)-\(engineCEWear)-\(engineICEWear)-\(engineMGUKWear)-\(engineTCWear)"
    }
    
}

internal struct TKCarDamagePacket: TKPacket {
    
    static let PACKET_SIZE_F1_2020: Int = 0 // Does not exist in F1 2020
    static let PACKET_SIZE_F1_2021: Int = TKPacketHeader.packetSize(forVersion: .f1_2021) + (Self.DRIVERS_COUNT * TKCarStatusData.packetSize(forVersion: .f1_2021))
    
    var header: TKPacketHeader
    var carDamageData: [TKCarDamageData] // 22
    
    init() {
        header = TKPacketHeader()
        carDamageData = [TKCarDamageData]()
    }
    
    mutating func build(fromRawData data: Data, at offset: Int, forVersion version: TKF1Version) {
        header = TKPacketHeader.build(fromRawData: data, forVersion: version)
        switch version {
        case .unknown:
            return
        case .f1_2020:
            return
        case .f1_2021:
            carDamageData = type(of: self).buildArray(ofSize: Self.DRIVERS_COUNT, fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 0, forVersion: version)
        }
    }
    
    func process(withDelegate delegate: TKDelegate) {
        delegate.update(carDamages: carDamageData)
    }

}

extension TKCarDamagePacket: CustomStringConvertible {
    
    var description: String {
        var lines = [String]()
        lines.append(header.description)
        for (index, cdd) in carDamageData.enumerated() {
            lines.append("\t\tCar \(index + 1): \(cdd.description)")
        }
        return lines.joined(separator: "\n")
    }
    
}
