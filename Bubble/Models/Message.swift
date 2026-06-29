//
//  Message.swift
//  Bubble
//
//  Created by Zachary Lam on 2026-06-26.
//

import Foundation

struct Message {
    let sender: String
    let body: String
    var date: Date {
        // Source - https://stackoverflow.com/a/78750754
        // Posted by JeremyP
        // Retrieved 2026-06-17, License - CC BY-SA 4.0
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let stringDate = formatter.string(from: today)
        
        return formatter.date(from: stringDate)!
    }
}
