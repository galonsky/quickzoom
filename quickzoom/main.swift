//
//  main.swift
//  quickzoom
//
//  Created by Alex Galonsky on 5/21/23.
//

import Foundation
import EventKit
import QuickzoomLib


print("Hello, World!")

let fetcher = EventFetcher()
fetcher.requestAccess()
do {
    if let events = try fetcher.getEvents() {
        let zoomEvents = events.compactMap { parseEvent(event: $0)}
        let alfredJson = try serializeForAlfred(events: zoomEvents)
        print(alfredJson)
    }
    
} catch NoAccessError.runtimeError {
    exit(EXIT_FAILURE)
}
