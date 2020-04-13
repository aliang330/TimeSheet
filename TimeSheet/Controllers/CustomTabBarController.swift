//
//  CustomTabBarController.swift
//  TimeSheet
//
//  Created by Allen on 4/13/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeController = ViewController()
        homeController.tabBarItem.title = "Home"
        homeController.tabBarItem.image = UIImage(systemName: "house.fill")
        
        let timeSheetController = CalendarController()
        timeSheetController.tabBarItem.title = "TimeSheet"
        timeSheetController.tabBarItem.image = UIImage(systemName: "calendar")
        viewControllers = [homeController, timeSheetController]
    }
    


}
