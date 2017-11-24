//
//  ViewController.swift
//  Ohm's Law Calculator
//
//  Created by Christine Berger on 10/26/17.
//  Credit to Nahuel Alejandro Veron for translating to the Spanish (Argentina) dialect.
//  Copyright © 2017 Christine Berger. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /*--------------------------------- VARIABLES ------------------------------------------*/
    /*== UI REFERENCE VARIABLES ==*/
    //BUTTONS =- 0.Voltage - 1.Current - 2.Resistance - 3.Calculate - 4.Close - 5.Exit App
    @IBOutlet var buttons: [UIButton]!
    //TEXTFIELDS =- 0.Voltage - 1.Current - 2.Resistance
    @IBOutlet var inputs: [UITextField]!
    //TEXTFIELD LABELS =- 0.Voltage - 1.Current - 2.Resistance
    @IBOutlet var labels: [UILabel]!
    //UNIT LABEL CONTAINERS =- 0.Volts Container - 1.Amps Container - 2.Ohms Container
    @IBOutlet var textfield_containers: [UIView]!
    //UNIT LABELS =- 0.Volts - 1.Amps - 2. Ohms
    @IBOutlet var unit_labels: [UILabel]!
    
    //Error View Container and Text Label (respectively)
    @IBOutlet weak var error_box:UIView!
    @IBOutlet weak var error_label:UILabel!
    
    /*== INTERNAL VARIABLES ==*/
    //Flags for determining if the inputs are filled
    //(used to enable/disable calculate button) */
    var filled_inputs: [Bool] = [false, false, false]
    
    //Keeps the old input on focus in order to keep the same calculation
    //result if the input does not change immediately
    var old_input:String = ""
    
    //Header Labels
    @IBOutlet weak var app_title: UILabel!
    @IBOutlet weak var app_description: UILabel!
    
    let local_num = NumberFormatter()
    
    /*---------------------------------- INITIALIZE APP ------------------------------------*/
    /*===============================================================
     * viewDidLoad()
     * Initialize the default state of the app.
     *==============================================================*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the border radius for all buttons.
        for button in buttons {
            button.layer.cornerRadius = 5
        }
        
        //=- Localized number format settings -=//
        //Set the local number format by using the current locale.
        local_num.locale = NSLocale.current
        //Set the properties of the local number format.
        //This is a fractional number
        local_num.numberStyle = NumberFormatter.Style.decimal
        //Allow only 2 places in the fractional portion of the number.
        local_num.maximumFractionDigits = 2
        //When truncating the fractional part, do not round.
        local_num.roundingMode = NumberFormatter.RoundingMode.down
        //Do not use grouping seperators (For example, the comma in 1,000.)
        local_num.usesGroupingSeparator = false
       
        //=- Set dynamic localized strings, where applicable -=//
        //Set the text for the default and disabled states of the 'Calculate!' button.
        buttons[3].setTitle(Strings.Buttons.calcDisabled, for: .disabled)
        buttons[3].setTitle(Strings.Buttons.calc, for: .normal)
        
        //Set the initial tab and it's contents.
        setTab(0)

        //Set a listener on the main view (Used for UITextField interaction)
        let tapGestureBackground = UITapGestureRecognizer(
            target: self, action: #selector(self.backgroundTapped(_:))
        )
        //Add the listener to the view.
        self.view.addGestureRecognizer(tapGestureBackground)
    }
    
    /*----------------------------------- UI LISTENERS ------------------------------------*/
    /*================================================================
     * onFocus(UITextField)
     * When a UITextField is in focus, this onFocus listener selects
     * all the current text in the text field.
     *==============================================================*/
    @IBAction func onFocus(_ sender: UITextField) {
        DispatchQueue.main.async {
            sender.selectAll(nil)
        }
        
        //If the sender text has something in it, keep the input
        //for the checkInput() function.
        if sender.text != "" {
            old_input = sender.text!
        }
    }
    
    /*================================================================
     * textDidChange(UITextField)
     * Detects when the text in the input field is changed.
     *==============================================================*/
    @IBAction func textDidChange(_ sender: UITextField!) {
        checkInput(sender, false)
    }
    
    /*===============================================================
     * textEditingEnded()
     * Detects when a text field is out of focus.
     *==============================================================*/
    @IBAction func textEditingEnded(_ sender: UITextField!) {
        checkInput(sender, true)
    }
    
    /*===============================================================
     * backgroundTapped()
     * If the background is tapped, end editing on any UITextField.
     *==============================================================*/
    @objc func backgroundTapped(_ sender: UITapGestureRecognizer)
    {
        self.view.endEditing(true)          //End any editing state.
    }
    
    /*===============================================================
     * buttonClicked()
     * Controls what happens when one of the UIButtons are clicked.
     *==============================================================*/
    @IBAction func buttonClicked(_ sender: UIButton) {
        
        //End any active editing on the textfields.
        self.view.endEditing(true)
        
        //Get the button that invoked this function by it's id (tag)
        let button_caller = sender.tag
        
        //If the button id(tag) that invoked this is a tab:
        if button_caller < 3 {
            
            //Set the tab and it's elements.
            setTab(button_caller)
            
        //Otherwise, it's another button
        } else {
            switch(button_caller) {
                //Calculate Button
                case 3:
                    findCalculation()
                //Error Close Button
                case 4:
                    //Clear the error text.
                    error_label.text = ""
                    //Hide the error container.
                    error_box.isHidden = true
                //Exit the app
                case 5:
                    showExitModal()
                //Default - Do nothing.
                default: ()
            }
        }
    }
    
    /*----------------------------------- PROCESSES ------------------------------------*/
    /*===============================================================
     * toggleCalcBtn()
     * If true, enables the button and sets it to the enabled state.
     * If false, disables the button and sets in to the disabled state.
     *==============================================================*/
    func toggleCalcBtn(_ is_on:Bool) {
        
        if(is_on) {
            buttons[3].backgroundColor = Color.primaryTheme         //Set the button to enabled color
            buttons[3].isEnabled = true                             //Enable the button
        } else {
            buttons[3].backgroundColor = Color.disabledDark         //Set the button to disabled color
            buttons[3].isEnabled = false                            //Disable the button.
        }
    }

    /*===============================================================
     * showExitModal()
     * Shows an exit modal and allows the user to stay in or exit the
     * app.
     *==============================================================*/
    func showExitModal() {
        
        //Create a new UIAlertController and set the title/message.
        let alert = UIAlertController(title: Strings.ExitModal.title,
                                      message: Strings.ExitModal.verifyExit,
                                      preferredStyle: .alert)
        
        //Add an action to stay in the app.
        alert.addAction(UIAlertAction(
            title: Strings.Buttons.stay,
            style: .default,
            handler: { _ in }))
        
        //Add an action to exit the app
        alert.addAction(UIAlertAction(
            title: Strings.Buttons.exit,
            style: .destructive,
            handler: { _ in
                //Exit app.
                exit(EXIT_SUCCESS)
        }))
        
        //Show the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    /*===============================================================
     * setTab()
     * Sets up the tab and it's contents.
     *==============================================================*/
    func setTab(_ selected:Int) {
        
        //For each element in inputs (there are 3, this is important as buttons has 5):
        for(tag_num, input) in inputs.enumerated() {
            
            //If the selected item matches the index number of the loop:
            if selected == tag_num {
                
                //Set the button with the same tag number to selected.
                buttons[tag_num].isSelected = true
                buttons[tag_num].backgroundColor = Color.primaryTheme
                
                //Set the input field with the same name as the tab to false, because
                //this is the value to be calculated.
                input.isEnabled = false
                
                //Set the assiciated text field to disabled.
                toggleTextfieldState(false, nil, tag_num)
            
            //Otherwise, the button is not selected and:
            } else {
                
                //Set the button to the default state
                buttons[tag_num].isSelected = false
                buttons[tag_num].backgroundColor = Color.primaryLight
                
                //Allow input on field of the same name.
                input.isEnabled = true
                
                //Enable the associated text field.
                toggleTextfieldState(true, nil, tag_num)
            }
            
            //Clear the text input field.
            input.text = ""
        }
        
        //Clear the flags for all inputs.
        filled_inputs = [ false, false, false ]
    }
    
    /*================================================================
     * checkInput()
     * Checks the input when the text in a UITextField is changed.
     * It gives an error message if the input is not valid or changes
     * the input into the proper precision float.
     *===============================================================*/
    func checkInput(_ sender:UITextField, _ isDoneEditing:Bool) {
        
        let tag = sender.tag              //Get the sender that invoked this function (identified by tags)
        var input_title:String = ""       //Holds the name of the field that was edited.
        var error_msg = ""                //Holds an error message to be output to the user, if there is one.
    
        //Use the tag id to determine the label of the textfield being edited and get the label text.
        for(count, label) in labels.enumerated() {
            if tag == count {
                input_title = label.text!
            }
        }
        
        //Don't let any whitespaces in the textfield.
        sender.text = sender.text!.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")
    
        //If the sender text (after formatting) is not the same as the old input, then clear the current calculated answer.
        //(Prevents the answer from clearing if user taps on the field but doesn't change anything.)
        if(sender.text != old_input) {
            inputs[findSelectedTab()].text = ""
        }
        
        //Get the input from the textfield and try to cast it into a Float
        let input = local_num.number(from: sender.text!)
        
        //If the input in the textfield is a float:
        if input != nil {
            
            //Set the error message to nothing to clear any errors.
            toggleTextfieldState(true, nil, tag)
            
            //Set the flag for the input field to true (the value is filled)
            filled_inputs[tag] = true
            
            //Format the float to two decimal places if the editing has finished.
            if isDoneEditing {
                sender.text = local_num.string(from: input!)
            }
            
        //If the input is not a float:
        } else {
            
            //If the original input is not empty (this prevents an error for just clicking on the field)
            if(sender.text! != "") {
                //Set the error message.
                error_msg += Strings.ErrorMessages.numFormat
                
                //If editing has ended on the textfield:
                if isDoneEditing {
                    //Set the message to trigger an error.
                    sender.text = Strings.ErrorMessages.unknownFormat
                }
                
                //Display an error message on the texfield.
                toggleTextfieldState(true, String.localizedStringWithFormat(error_msg, input_title), tag)
                
            } else {
                toggleTextfieldState(true, nil, tag)
            }
            
            //Thefield has not been filled correctly, so set it as false.
            filled_inputs[tag] = false
        }
        
        //Enable or Disable the Calculate button based on the flags.
        setCalcButton()
    }
    
    /*================================================================
     * toggleTextfieldState()
     * Changes the state of the textfield (error, disabled, normal)
     *===============================================================*/
    func toggleTextfieldState(_ enabled:Bool, _ msg:String?, _ id:Int) {
        
        //Clear all borders.
        textfield_containers[id].layer.borderWidth = 0
        
        //If the button is enabled:
        if enabled {
            //Set the background to white.
            textfield_containers[id].backgroundColor = UIColor.white
        //If it's disabled:
        } else {
            //Set the backgroud to grey.
            textfield_containers[id].backgroundColor = Color.disabled
        }
        
        //If a message was sent by the invoker:
        if msg != nil {
            //Set the error message and show the error container.
            error_label.text = msg
            error_box.isHidden = false
        
            //Set the error box to the error color (pinkish-red)
            error_box.layer.backgroundColor = Color.error.cgColor
        
            //Set the error sate of the textfield that threw the error.
            textfield_containers[id].layer.borderWidth = 1.0
            textfield_containers[id].layer.borderColor = Color.error.cgColor
            
        //Otherwise, clear and hide the error container.
        } else {
            //Clear and hide the error container
            error_label.text = ""
            error_box.isHidden = true
        }
    }
    
    /*================================================================
     * setCalcButton()
     * Checks the flags for each input field and enables the Calculate
     * button when two fields are filled.
     *===============================================================*/
    func setCalcButton() {
        
        //Counter variable that counts the number of filled inputs.
        var count = 0
        
        //Check each filled input flag
        for filled_input in filled_inputs {
            //If the current filled input is true, count up one.
            if(filled_input) {
                count += 1
            }
        }
        
        //If the number of filled fields is two:
        if count == 2 {
            //Enable the Calculate Button
            toggleCalcBtn(true)
        } else {
            //Otherwise, disable the Calculate button.
            toggleCalcBtn(false)
        }
    }
    
    /*===============================================================
     * findCalculation()
     * Executes the calculation based on the current tab.
     *==============================================================*/
    func findCalculation() {
        
        //Get the selected tab.
        let tab_id = findSelectedTab()
        var answer:Float = 0.0
        
        switch(tab_id) {
            case 0:
                
                //Can't use Float(input) because it doesn't convert to the local number system.
                let current = local_num.number(from: inputs[1].text!)?.floatValue
                let resistance = local_num.number(from: inputs[2].text!)?.floatValue
                
                answer = multiply(current!, resistance!)
                inputs[tab_id].text = local_num.string(from: NSNumber(value: answer))
            case 1:
                let voltage = local_num.number(from: inputs[0].text!)?.floatValue
                let resistance = local_num.number(from: inputs[2].text!)?.floatValue
                
                answer = divide(voltage!, resistance!)
            case 2:
                let voltage = local_num.number(from: inputs[0].text!)?.floatValue
                let current = local_num.number(from: inputs[1].text!)?.floatValue
                
                answer = divide(voltage!, current!)
            default: ()
        }
        
        inputs[tab_id].text = local_num.string(from: NSNumber(value: answer))
    }
    
    /*===============================================================
     * findSelectedTab()
     * Returns the tab that's currently selected.
     *==============================================================*/
    func findSelectedTab()->Int {
        
        //Initialize the tab ID with a number that is not a tab identifier.
        var selected_tab_num = -99
        
        //For all of the buttons that are associated with a tab in the UI,
        //check which is selected.
        for index in 0...buttons.count where index < 3 {
            if buttons[index].isSelected == true {
                selected_tab_num = buttons[index].tag
            }
        }
        
        //Return the selected tab.
        return selected_tab_num
    }
    
    /*===============================================================
     * multiply()
     * Multiplies two values together.
     *==============================================================*/
    func multiply(_ left_value:Float, _ right_value:Float)->Float {
        
        //Do the multiplication.
        return left_value * right_value
    }
    
    /*===============================================================
     * divide()
     * Divides one value by another.
     *==============================================================*/
    func divide(_ top_value:Float, _ bottom_value:Float)->Float {
        
        //Do the division.
        return top_value / bottom_value
    }
}

