//
//  DataManager.swift
//  TimeSheet
//
//  Created by Allen on 4/2/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    
    func checkIfDataFileExists() ->NSMutableDictionary {
        let url = FileManager.documentDirectoryURL.appendingPathComponent("data")
        let fileManager = FileManager.default
        
        if !fileManager.fileExists(atPath: url.path) {
            let data: NSMutableDictionary = ["isPunchedIn" : "false",
                                             "timePunchedIn" : 0,
                                             "totalTimeWorked" : 0
            ]
            data.write(to: url, atomically: true)
            return data
        }
        return NSMutableDictionary(contentsOf: url)!
    }
    
    func saveData(data: NSMutableDictionary) {
        data.write(to: FileManager.documentDirectoryURL.appendingPathComponent("data"), atomically: true)
    }
    
    func saveJson(timeSheet: TimeSheet) {
        let url = FileManager.documentDirectoryURL.appendingPathComponent("timeSheet.json")
        let json = try? JSONEncoder().encode(timeSheet)
        do {
            try json?.write(to: url)
        } catch {
            print(error)
        }
    }
    
    func loadJson() -> TimeSheet{
        let url = FileManager.documentDirectoryURL.appendingPathComponent("timeSheet.json")
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: url.path) {
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            guard let currentDate = Calendar.current.date(from: dateComponents) else { return TimeSheet() }
            let currentDateSince1970 = Int(currentDate.timeIntervalSince1970)
            let day = Day(dateSince1970: currentDateSince1970, punchIn: [Int]())
            let timeSheet = TimeSheet(days: [day])
            DataManager.shared.saveJson(timeSheet: timeSheet)
        }
        
        guard let data = try? Data(contentsOf: url) else { return TimeSheet() }
        do {
            let decodedData = try JSONDecoder().decode(TimeSheet.self, from: data)
            return decodedData
        } catch {
            return TimeSheet()
        }
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }

}
