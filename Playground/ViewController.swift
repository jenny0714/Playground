//
//  ViewController.swift
//  Playground
//
//  Created by Jenny Lin on 2021/3/3.
//

import UIKit

struct CryptoRate: Codable {
    var timestamp: Int
    var data: CryptoData
}

struct CryptoData: Codable  {
    var currencySymbol: String
    var id: String
    var rateUsd: String
    var symbol: String
    var type: String
}

class ViewController: UIViewController {
    @IBOutlet weak var priceField: UITextField!
    @IBAction func showMessage(sender: UIButton) {
        GetBTCAsync()
    }
    
    func GetBTCAsync(){
        let urlString = URL(string: "https://api.coincap.io/v2/rates/bitcoin")
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else { return }
                self.ParseJSON(data: data)
            }
            task.resume()
        }
    }
    
    func ParseJSON(data: Data?){
        guard let data = data else { return }
        let crypto = try! JSONDecoder().decode(CryptoRate.self, from: data)
        DispatchQueue.main.async{self.priceField.text = crypto.data.rateUsd}
    }
    
    func TurnAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
