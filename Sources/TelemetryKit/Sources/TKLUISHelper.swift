//
//  TKLUISHelper.swift
//  TelemetryKit
//
//  Created by Romain on 11/08/2019.
//  Copyright © 2019 Poulpix. All rights reserved.
//

import Foundation

internal enum TKLUISError: Error {
	
	case httpCodeError(statusCode: Int)
	case mimeTypeError(mimeType: String)
	case intentHandlingError(intent: TKRaceEngineerQueryIntent)
	
}

internal struct TKLUISResponse: Codable {
	
	let query: String
	let topScoringIntent: TKLUISIntent
	let intents: [TKLUISIntent]
	let entities: [TKLUISEntity]
	
	func firstEntity(ofType entityType: TKLUISEntityType) -> TKLUISEntity? {
		for e in entities {
			if e.type == entityType {
				return e
			}
		}
		return nil
	}
	
}

internal struct TKLUISIntent: Codable {
	
	let intent: TKRaceEngineerQueryIntent
	let score: Float
	
}

internal enum TKLUISEntityType: String, Codable {
	
	case driver = "Driver"
	case team = "Team"
	case position = "Position"
	
}

internal struct TKLUISEntity: Codable {
	
	let entity: String
	let type: TKLUISEntityType
	let startIndex: UInt
	let endIndex: UInt
	let resolution: TKLUISEntityResolution
	let role: String?
	
	var identifier: String {
		return resolution.values.first!
	}
	
}

internal struct TKLUISEntityResolution: Codable {
	
	let values: [String]
	
}
