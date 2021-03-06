//
//  KeyboardViewControllerBase.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2016-01-31.
//  Copyright © 2016 Daniel Saidi. All rights reserved.
//

import UIKit

public class KeyboardInputViewController: UIInputViewController, KeyboardDelegate {

    
    // MARK: View lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboard()
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        setupKeyboard()
    }
    
    public override func updateViewConstraints() {
        super.updateViewConstraints()
        setupKeyboard()
    }
    
    
    
    // MARK: Properties
    
    public var keyboard: Keyboard! {
        didSet { keyboard.delegate = self }
    }
    
    public var lastPageNumber: Int {
        get { return settings.integerForKey("lastPageNumber") }
        set { settings.setInteger(keyboard.pageNumber, forKey: "lastPageNumber") }
    }
    
    public var openAccessEnabled: Bool {
        get { return UIPasteboard.generalPasteboard().isKindOfClass(UIPasteboard) }
    }
    
    public var settings: NSUserDefaults {
        get { return NSUserDefaults.standardUserDefaults() }
    }
    
    
    
    // MARK: Public functions
    
    public func createKeyboard() -> Keyboard! {
        alertMissingImplementation("createKeyboard()")
        return nil
    }
    
    public func setupKeyboard() {
        keyboard = createKeyboard()
        keyboard.setupKeyboardInViewController(self)
        keyboard.pageNumber = lastPageNumber
    }
    
    
    
    // MARK: Private functions
    
    private func alertMissingImplementation(functionName: String) {
        print("** WARNING! '\(functionName)\' not implemented in KeyboardInputViewController subclass **")
    }
    
    
    
    // MARK: KeyboardDelegate
    
    public func keyboard(keyboard: Keyboard, buttonLongPressed button: KeyboardButton) {
    }
    
    public func keyboard(keyboard: Keyboard, buttonTapped button: KeyboardButton) {
        if let _ = button.operation {
            switch (button.operation!) {
            case .Backspace:
                textDocumentProxy.deleteBackward()
            case .NextKeyboard:
                advanceToNextInputMode()
            case .NewLine:
                textDocumentProxy.insertText("\n")
            case .Space:
                textDocumentProxy.insertText(" ")
            default:
                break
            }
        }
    }
    
    public func keyboardPageNumberDidChange(keyboard: Keyboard) {
        lastPageNumber = keyboard.pageNumber
        settings.synchronize()
    }
}
