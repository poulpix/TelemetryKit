//
//  TKPacketHeader.swift
//  TelemetryKit
//
//  Created by Romain on 06/07/2019.
//  Copyright © 2019 Poulpix. All rights reserved.
//

import Foundation

//FIXME: Reference for F1 2020: https://f1-2020-telemetry.readthedocs.io/en/latest/telemetry-specification.html
//FIXME: Reference for F1 2021: https://forums.codemasters.com/applications/core/interface/file/attachment.php?id=39117

internal struct TKPacketHeader: TKPacket {
	
	static let NO_SECOND_PLAYER: UInt8 = 255 // means there is no second player currently
	static let PACKET_SIZE_F1_2020: Int = 24
    static let PACKET_SIZE_F1_2021: Int = 24
	
	var isValidPacket: Bool {
        return packetFormat != .unknown
	}
	
	var playingWithSecondaryPlayer: Bool {
		return secondaryPlayerCarIndex != TKPacketHeader.NO_SECOND_PLAYER
	}
	
	var packetFormat: TKF1Version
	var gameMajorVersion: UInt8
	var gameMinorVersion: UInt8
	var packetVersion: UInt8
	var packetId: TKPacketType
	var sessionUID: UInt64
	var sessionTimestamp: Float32
	var frameIdentifier: UInt32
	var playerCarIndex: UInt8
	var secondaryPlayerCarIndex: UInt8

	init() {
        packetFormat = .unknown
		gameMajorVersion = 0
		gameMinorVersion = 0
		packetVersion = 0
		packetId = .motion
		sessionUID = 0
		sessionTimestamp = 0
		frameIdentifier = 0
		playerCarIndex = 0
		secondaryPlayerCarIndex = 0
	}
    
    static func build(fromRawData data: Data, at offset: Int = 0) -> Self {
        return build(fromRawData: data, at: offset, forVersion: .unknown)
    }
	
	mutating func build(fromRawData data: Data, at offset: Int = 0, forVersion version: TKF1Version) {
		packetFormat = type(of: self).readEnum(fromRawData: data, at: 0)
		gameMajorVersion = type(of: self).read(fromRawData: data, at: 2)
		gameMinorVersion = type(of: self).read(fromRawData: data, at: 3)
		packetVersion = type(of: self).read(fromRawData: data, at: 4)
		packetId = type(of: self).readEnum(fromRawData: data, at: 5)
		sessionUID = type(of: self).read(fromRawData: data, at: 6)
		sessionTimestamp = type(of: self).read(fromRawData: data, at: 14)
		frameIdentifier = type(of: self).read(fromRawData: data, at: 18)
		playerCarIndex = type(of: self).read(fromRawData: data, at: 22)
		secondaryPlayerCarIndex = type(of: self).read(fromRawData: data, at: 23)
	}
	
    func processFullPacket(withRawData data: Data, andDelegate delegate: TKDelegate) {
        switch packetId {
        case .motion:
            TKMotionPacket.build(fromRawData: data, forVersion: packetFormat).process(withDelegate: delegate)
        case .session:
            TKSessionPacket.build(fromRawData: data, forVersion: packetFormat).process(withDelegate: delegate)
        case .lapData:
            TKLapDataPacket.build(fromRawData: data, forVersion: packetFormat).process(withDelegate: delegate)
        case .event:
            TKEventPacket.build(fromRawData: data, forVersion: packetFormat).process(withDelegate: delegate)
        case .participants:
            TKParticipantsPacket.build(fromRawData: data, forVersion: packetFormat).process(withDelegate: delegate)
        case .carSetups:
            TKCarSetupsPacket.build(fromRawData: data, forVersion: packetFormat).process(withDelegate: delegate)
        case .carTelemetry:
            TKCarTelemetryPacket.build(fromRawData: data, forVersion: packetFormat).process(withDelegate: delegate)
        case .carStatus:
            TKCarStatusPacket.build(fromRawData: data, forVersion: packetFormat).process(withDelegate: delegate)
        case .finalClassification:
            TKFinalClassificationPacket.build(fromRawData: data, forVersion: packetFormat).process(withDelegate: delegate)
        case .lobbyInfo:
            TKLobbyInfoPacket.build(fromRawData: data, forVersion: packetFormat).process(withDelegate: delegate)
        case .carDamage: // New in F1 2021
            TKCarDamagePacket.build(fromRawData: data, forVersion: packetFormat).process(withDelegate: delegate)
        case .sessionHistory: // New in F1 2021
            TKSessionHistoryPacket.build(fromRawData: data, forVersion: packetFormat).process(withDelegate: delegate)
        }
	}
	
}

extension TKPacketHeader: CustomStringConvertible {
	
	var description: String {
		return "Packet format: \(packetFormat) – Game V\(gameMajorVersion).\(gameMinorVersion) – Packet \"\(packetId)\" (V\(packetVersion)) – Player is no \(playerCarIndex + 1) – \(playingWithSecondaryPlayer ? "Second player is no \(secondaryPlayerCarIndex + 1) – " : "")Session time: \(sessionTimestamp.asSessionTimeString)"
	}
	
}
