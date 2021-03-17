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

enum CurrencyType {
    case BTC
    case ETH
}

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var currencyDict: [String: String] = [
        "BTC" : "https://api.coincap.io/v2/rates/bitcoin",
        "ETH" : "https://api.coincap.io/v2/rates/ethereum"
    ]
    var urlString:URL?
  
    @IBOutlet weak var PriceLabel: UILabel!
    @IBOutlet weak var PickerView: UIPickerView!
    @IBOutlet weak var CurrencyLabel: UILabel!
    @IBOutlet weak var Button: UIButton!
    @IBOutlet var ChoiceView: UIView!
    let list = ["BTC", "ETH "]
    @IBAction func ChoiceClick(_ sender: Any) {
        PriceLabel.text = ""
        displayPickerView(true)
    }
    
    @IBAction func DownClick(_ sender: Any) {
        let title = list[PickerView.selectedRow(inComponent: 0)]
//      Button.setTitle(title, for: .normal)
        displayPickerView(false)
        CurrencyLabel.text = title
        
        if let url = currencyDict[title] {
            getCurrencyRate(_urlString: URL(string: url))
        }
    }
    
    func displayPickerView(_ show : Bool ){
        for c in view.constraints {
            if c.identifier == "bottom"{
                c.constant = (show) ? -10 : 128
                break
            }
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.addSubview(ChoiceView)
        ChoiceView.translatesAutoresizingMaskIntoConstraints = false
        ChoiceView.heightAnchor.constraint(equalToConstant: 128).isActive = true
        ChoiceView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        ChoiceView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        let c = ChoiceView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 128)
        c.identifier = "bottom"
        c.isActive = true
        
        ChoiceView.layer.cornerRadius = 10
        
        super.viewWillAppear(animated)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }
    
    func getCurrencyRate(_urlString: URL?){
        if let url = _urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else { return }
                self.parseJSON(data: data)
            }
            task.resume()
        }
    }
    
    func parseJSON(data: Data?){
        guard let data = data else { return }
        let crypto = try! JSONDecoder().decode(CryptoRate.self, from: data)
        DispatchQueue.main.async{
            self.PriceLabel.text = crypto.data.rateUsd
            
        }
    }
    
    func TurnAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

}
