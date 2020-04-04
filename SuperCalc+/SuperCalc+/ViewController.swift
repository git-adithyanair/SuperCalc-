//
//  ViewController.swift
//  SuperCalc+
//
//  Created by Adithya Nair on 12/13/19.
//  Copyright © 2019 Adithya Nair. All rights reserved.
//

import UIKit
import AVFoundation

@IBDesignable extension UIButton {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var number: UILabel!
    
    var player: AVAudioPlayer!
    
    var calculate: Double = 0
    var previousNumPressed = false
    var previousEqualsPressed = false
    var values = [Double]()
    var latestPos = -1
    var action = ""
    
    @IBAction func plusminusPressed(_ sender: UIButton) {
        playSoundSpacebar()
        previousNumPressed = false
        previousEqualsPressed = false
        calculate = -calculate
        number.text = String(calculate)
    }
    
    @IBAction func percentPressed(_ sender: UIButton) {
        playSoundSpacebar()
        previousNumPressed = false
        if (!previousEqualsPressed) {
            values.append(calculate)
            latestPos += 1
        }
        if (values.count >= 2) {
            calculate = (values[latestPos - 1] / values[latestPos]) * 100
            values.append(calculate)
            latestPos += 1
        }
        previousEqualsPressed = false
        number.text = String(calculate)
    }
    
    @IBAction func acPressed(_ sender: UIButton) {
        playSoundDelete()
        previousNumPressed = false
        previousEqualsPressed = false
        sender.alpha = 0.5
        number.text = "0"
        values.removeAll()
        latestPos = -1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            sender.alpha = 1
        }
    }
    
    @IBAction func equalPressed(_ sender: UIButton) {
        playSoundReturn()
        sender.alpha = 0.5
        if (previousEqualsPressed) {
            calculate = values[latestPos - 1]
        }
        values.append(calculate)
        latestPos += 1
        previousNumPressed = false
        if (action == "+") {
            calculate = values[latestPos - 1] + values[latestPos]
        } else if (action == "-") {
            calculate = values[latestPos - 1] - values[latestPos]
        } else if (action == "x") {
            calculate = values[latestPos - 1] * values[latestPos]
        } else if (action == "÷") {
            calculate = values[latestPos - 1] / values[latestPos]
        }
        values.append(calculate)
        latestPos += 1
        number.text = String(calculate)
        previousEqualsPressed = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            sender.alpha = 1
        }
    }
    
    @IBAction func actionPressed(_ sender: UIButton) {
        playSoundSpacebar()
        sender.alpha = 0.5
        if (!previousEqualsPressed) {
            values.append(calculate)
            latestPos += 1
        }
        previousNumPressed = false
        if (values.count >= 2 && !previousEqualsPressed) {
            if (action == "+") {
                calculate = values[latestPos - 1] + values[latestPos]
            } else if (action == "-") {
                calculate = values[latestPos - 1] - values[latestPos]
            } else if (action == "x") {
                calculate = values[latestPos - 1] * values[latestPos]
            } else if (action == "÷") {
                calculate = values[latestPos - 1] / values[latestPos]
            }
            values.append(calculate)
            latestPos += 1
            number.text = String(calculate)
        }
        calculate = 0
        action = sender.currentTitle!
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            sender.alpha = 1
        }
    }
    
    @IBAction func numberPressed(_ sender: UIButton) {
        playSoundStandard()
        sender.alpha = 0.5
        previousEqualsPressed = false
        if (previousNumPressed) {
            number.text = number.text! + sender.currentTitle!
        } else {
            number.text = ""
            number.text = number.text! + sender.currentTitle!
        }
        previousNumPressed = true
        if (number.text != ".") {
            calculate = Double(number.text!)!
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            sender.alpha = 1
        }
    }
    
    func playSoundStandard() {
        let url = Bundle.main.url(forResource: "KeypressStandard", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }
    
    func playSoundDelete() {
        let url = Bundle.main.url(forResource: "KeypressDelete", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }
    
    func playSoundReturn() {
        let url = Bundle.main.url(forResource: "KeypressReturn", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }
    
    func playSoundSpacebar() {
        let url = Bundle.main.url(forResource: "KeypressSpacebar", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }
    
}

