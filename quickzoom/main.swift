//
//  main.swift
//  quickzoom
//
//  Created by Alex Galonsky on 5/21/23.
//

import Foundation
import EventKit

enum NoAccessError: Error {
    case runtimeError
}

class EventFetcher {
    var store = EKEventStore()
    var granted: Bool = false
    var denied: Bool = false
    
    func getEvents() throws -> [EKEvent]? {
        while(!self.granted) {
            if (self.denied) {
                throw NoAccessError.runtimeError
            }
            sleep(1)
        }
        
        // Get the appropriate calendar.
        let calendar = Calendar.current

        // Create the start date components
        var oneDayAgoComponents = DateComponents()
        oneDayAgoComponents.day = -1
        let oneDayAgo = calendar.date(byAdding: oneDayAgoComponents, to: Date(), wrappingComponents: false)

        // Create the end date components.
        var oneDayFromNowComponents = DateComponents()
        oneDayFromNowComponents.day = 1
        let oneDayFromNow = calendar.date(byAdding: oneDayFromNowComponents, to: Date(), wrappingComponents: false)

        // Create the predicate from the event store's instance method.
        var predicate: NSPredicate? = nil
        if let anAgo = oneDayAgo, let aNow = oneDayFromNow {
            predicate = store.predicateForEvents(withStart: anAgo, end: aNow, calendars: nil)
        }

        // Fetch all events that match the predicate.
        var events: [EKEvent]? = nil
        if let aPredicate = predicate {
            events = store.events(matching: aPredicate)
            return events
        }
        return events
    }
    
    func requestAccess() {
        store.requestAccess(to: .event, completion: {(accessGranted: Bool, error: Error?) in
            if (!accessGranted) {
                self.denied = true
            }
            self.granted = accessGranted
        })
    }
}


print("Hello, World!")

let fetcher = EventFetcher()
fetcher.requestAccess()
do {
    try print(fetcher.getEvents())
} catch NoAccessError.runtimeError {
    exit(EXIT_FAILURE)
}
