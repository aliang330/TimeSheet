//
//  ViewController.swift
//  TimeSheet
//
//  Created by Allen on 4/1/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import UIKit


struct TimeSheet: Codable{
    var days: [Day]?
}

struct Day : Codable {
    var dateSince1970: Int?
    var PunchIn: [Int]?
    var PunchOut: [Int]?
}

class ViewController: UIViewController {

    
    var isPunchedIn = false
    var timePunchedIn = 0
    var totalTimeWorked = 0
    
    var loadedData: NSMutableDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        loadedData = DataManager.shared.checkIfDataFileExists()
        loadData(from: loadedData)
        setupView()
        updateUI()
    }
    
    
    
    let punchInButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .green
        button.setTitle("Punch In", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 24)
        button.addTarget(self, action: #selector(handlePunch), for: .touchUpInside)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        return button
    }()
    
    let punchOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Punch Out", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 24)
        button.addTarget(self, action: #selector(handlePunch), for: .touchUpInside)
        button.layer.cornerRadius = 12
        button.backgroundColor = .red
        button.layer.borderWidth = 1
        return button
    }()
    
    let timeWorkedLabel = UILabel(text: "00:00:00", font: .boldSystemFont(ofSize: 60))
    
    
    let workLabel = UILabel(text: "Time Worked", font: .boldSystemFont(ofSize: 40))
    
    
    
    @objc func handlePunch() {
        let url = FileManager.documentDirectoryURL.appendingPathComponent("timeSheet.json")
        let fileManager = FileManager.default
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        guard let currentDate = Calendar.current.date(from: dateComponents) else { return }
        let currentDateSince1970 = Int(currentDate.timeIntervalSince1970)
        
        if isPunchedIn == false {
            isPunchedIn = true
            punchInButton.isHidden = true
            punchOutButton.isHidden = false
            timePunchedIn = Int(Date().timeIntervalSince1970)
            DataManager.shared.saveData(data: createData())
            
            //check if file exists
            
            
            if fileManager.fileExists(atPath: url.path) {
                guard let data = try? Data(contentsOf: url) else { return }
                guard var decodedData = try? JSONDecoder().decode(TimeSheet.self, from: data) else { return }
                //check if today exist
                var todayExist = false
                guard let daysArray = decodedData.days else { return }
                
                for (index, day) in daysArray.enumerated() {
                    if day.dateSince1970 == currentDateSince1970 {
                        //today exist
                        todayExist = true
                        print("punch in")
                        print("before append")
                        print(decodedData)
                        decodedData.days?[index].PunchIn?.append(timePunchedIn)
                        print("after append")
                        print(decodedData)
                        DataManager.shared.saveJson(timeSheet: decodedData)
                        break
                    }
                }
                if todayExist == false {
                    //today doesnt exist
                    var newDay = Day()
                    newDay.dateSince1970 = currentDateSince1970
                    newDay.PunchIn = [timePunchedIn]
                    newDay.PunchOut = [Int]()
                    decodedData.days?.append(newDay)
                    DataManager.shared.saveJson(timeSheet: decodedData)
                    print(decodedData)
                }
            } else {
                //create file
                print("create file")
                var timeSheet = TimeSheet()
                var day = Day()
                day.dateSince1970 = currentDateSince1970
                day.PunchIn = [Int]()
                day.PunchOut = [Int]()
                timeSheet.days = [day]
                DataManager.shared.saveJson(timeSheet: timeSheet)
            }
        } else {
            isPunchedIn = false
            punchOutButton.isHidden = true
            punchInButton.isHidden = false
            totalTimeWorked += Int(NSDate().timeIntervalSince1970) - timePunchedIn
            updateUI()
            DataManager.shared.saveData(data: createData())
            
            guard let data = try? Data(contentsOf: url) else { return }
            do {
                var decodedData = try JSONDecoder().decode(TimeSheet.self, from: data)
                guard let days = decodedData.days else { return }
                for (index, day) in days.enumerated() {
                    if day.dateSince1970 == currentDateSince1970 {
                        decodedData.days?[index].PunchIn?.append(Int(Date().timeIntervalSince1970))
                        DataManager.shared.saveJson(timeSheet: decodedData)
                        break
                    }
                }
            } catch {
                print(error)
            }
            
        }
        
    }
    
    func createData() -> NSMutableDictionary {
        let data: NSMutableDictionary = ["isPunchedIn" : isPunchedIn == true ? "true" : "false",
                                         "timePunchedIn" : timePunchedIn,
                                         "totalTimeWorked" : totalTimeWorked
        ]
        return data
    }
    
    func loadData(from data: NSMutableDictionary) {
        isPunchedIn = data["isPunchedIn"] as! String == "true" ? true : false
        timePunchedIn = data["timePunchedIn"] as! Int
        totalTimeWorked = data["totalTimeWorked"] as! Int
    }
    
    func updateUI() {
        
        
        let (h, m , s) = DataManager.shared.secondsToHoursMinutesSeconds(seconds: totalTimeWorked)
        
        var timeString = ""
        
        if h < 10 {
            timeString += "0\(h):"
        } else {
            timeString += "\(h):"
        }
        if m < 10 {
            timeString += "0\(m):"
        } else {
            timeString += "\(m):"
        }
        if s < 10 {
            timeString += "0\(s)"
        } else{
            timeString += "\(s)"
        }
        
        timeWorkedLabel.text = timeString
        
    }
    
    
    
    func setupView() {
        
        if isPunchedIn == false {
            punchInButton.isHidden = false
            punchOutButton.isHidden = true
        } else {
            punchInButton.isHidden = true
            punchOutButton.isHidden = false
        }
            
        updateUI()
        let punchButtonStackView = UIStackView(arrangedSubviews: [punchInButton, punchOutButton])
        
        punchButtonStackView.spacing = 100
        punchButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(punchButtonStackView)
        
        punchButtonStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        punchButtonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        punchButtonStackView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        punchButtonStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(timeWorkedLabel)
        
        timeWorkedLabel.topAnchor.constraint(equalTo: punchButtonStackView.bottomAnchor, constant: 300).isActive = true
        timeWorkedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timeWorkedLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 60).isActive = true
        timeWorkedLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        view.addSubview(workLabel)
        
        workLabel.bottomAnchor.constraint(equalTo: timeWorkedLabel.topAnchor, constant: -30).isActive = true
        workLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

}


extension FileManager {
    static var documentDirectoryURL: URL {
        return `default`.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
