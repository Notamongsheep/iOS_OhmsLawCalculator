//
//  Structs.swift
//  Ohm's Law Calculator
//
//  Created by Christine Berger on 10/30/17.
//  Credit to Nahuel Alejandro Veron for translating to the Spanish (Argentina) dialect.
//  Copyright © 2017 Christine Berger. All rights reserved.
//

import Foundation
import UIKit

struct Color {
    static let error = UIColor(red: 233.0 / 255.0, green: 30.0 / 255.0, blue: 99.0 / 255.0, alpha: 1.0)
    static let info = UIColor(red: 30.0 / 255.0, green: 201.0 / 255.0, blue: 233.0 / 255.0, alpha: 1.0)
    static let primaryLight = UIColor(red: 151.0 / 255.0, green: 222.0 / 255.0, blue: 173.0 / 255.0, alpha: 1.0)
    static let primaryTheme = UIColor(red: 99.0 / 255.0, green: 211.0 / 255.0, blue: 133.0 / 255.0, alpha: 1.0)
    static let disabled = UIColor(red: 230.0 / 255.0, green: 230.0 / 255.0, blue: 230.0 / 255.0, alpha: 1.0)
    static let disabledDark = UIColor(red: 150.0 / 255.0, green: 150.0 / 255.0, blue: 150.0 / 255.0, alpha: 1.0)
}

struct Strings {
   
    struct Buttons {
        static let calcDisabled = NSLocalizedString("Calc Disabled", value: "Fill in the required values to calculate.",  comment: "Disabled calculate button")
        static let calc = NSLocalizedString("Calc", value:"Calculate!", comment: "Calculate button")
        static let stay = NSLocalizedString("Stay", value: "Stay", comment: "Cancel Button for Exit Modal")
        static let exit = NSLocalizedString("Exit", value: "Exit", comment: "Exit Button for Exit Modal")
    }
    
    struct ExitModal {
        static let title = NSLocalizedString("Exit App Modal Title", value: "Exit Ohm's Law Calculator", comment: "Exit modal title")
        static let verifyExit = NSLocalizedString("Verify Exit", value: "Are you sure you want to exit?", comment: "Question to verify the user wants to exit")
    }
    
    struct ErrorMessages {
        static let numFormat = NSLocalizedString("Number Format", value: "The value given for %@ must be a number. (Examples: 1, 1.0, 3.14)", comment: "Number Error Message")
        static let unknownFormat = NSLocalizedString("Unknown Format", value: "???", comment: "Unknown Input Error")
    }
}
