//
//  main.swift
//  AdventOfCode2017
//
//  Created by Frank Guchelaar on 29/11/2017.
//  Copyright © 2017 Awesomation. All rights reserved.
//

import Foundation

var components = DateComponents()
components.year = 2017
components.month = 12
components.day = 1
components.timeZone = TimeZone(abbreviation: "EST")

let date = Calendar(identifier: .gregorian).date(from: components)!

let difference = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(), to: date)

print (difference)
