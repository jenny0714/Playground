//
//  ViewController.swift
//  Playground
//
//  Created by Jenny Lin on 2021/3/3.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var textField1: UITextField!
    @IBAction func showMessage(sender: UIButton) {
    
        let alertController = UIAlertController(title: "Hi your answer is", message: textField1.text, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
}

