//
//  CalendarViewController.swift
//  ShoppingNotebook
//
//  Created by carina  dos santos pereira on 04/12/16.
//  Copyright © 2016 carina  dos santos pereira. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {

    @IBOutlet weak var fsCalendar: FSCalendar!
    private weak var calendar: FSCalendar!
    var dataSelecionada = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fsCalendar.dataSource = self
        fsCalendar.delegate = self
        fsCalendar.locale = NSLocale(localeIdentifier: "pt_BR") as Locale
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dataSelecionada = dateFormatter.string(from: date)
        
        self.performSegue(withIdentifier: "segueTotais", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueTotais"{
            let view = segue.destination as! TransactionsViewController
            view.dataSelecionada = self.dataSelecionada
        }else{
            Alert(controller: self).showErro()
        }
    }

}
