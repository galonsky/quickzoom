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
    let events = try fetcher.getEvents()
    
} catch NoAccessError.runtimeError {
    exit(EXIT_FAILURE)
}
