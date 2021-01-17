//
//  TKViewLibrary.swift
//  TelemetryKit
//
//  Created by Romain on 03/01/2021.
//  Copyright © 2021 Poulpix. All rights reserved.
//

import Foundation
import SwiftUI

struct TKViewLibrary: LibraryContentProvider {
	
	@LibraryContentBuilder
	var views: [LibraryItem] {
		LibraryItem(TKImage("TelemetryIcon"), title: "Image from the TelemetryKit package", category: .control)
		LibraryItem(TKTextLabelView("Label:", data: .constant("test")), title: "Label with data (of string type)", category: .control)
		LibraryItem(TKBooleanLabelView("Label:", data: .constant(true)), title: "Label with data (of boolean type)", category: .control)
		LibraryItem(TKUInt8LabelView("Label:", data: .constant(123)), title: "Label with data (of UInt8 type)", category: .control)
		LibraryItem(TKUInt64LabelView("Label:", data: .constant(1234)), title: "Label with data (of UInt64 type)", category: .control)
		LibraryItem(TKDriverCompactView(TKDriverCompactView_Previews.$driver), title: "Represents a driver info (compact version)", category: .control)
        LibraryItem(TKDriverLargeView(TKDriverLargeView_Previews.$driver, fastestS1: TKDriverLargeView_Previews.$fastestS1, fastestS2: TKDriverLargeView_Previews.$fastestS2, fastestS3: TKDriverLargeView_Previews.$fastestS3, fastestLap: TKDriverLargeView_Previews.$fastestLap, gapToLeader: TKDriverLargeView_Previews.$gapToLeader), title: "Represents a driver info (large version)", category: .control)
		LibraryItem(TKLiveRankingsLargeView(TKLiveRankingsLargeView_Previews.$liveSessionInfo), title: "Represents a live rankings view (large version)", category: .control)
		LibraryItem(TKTyreCompoundView(.constant(.f1ModernSoft)), title: "Represents a tyre compound", category: .control)
	}
 
}
