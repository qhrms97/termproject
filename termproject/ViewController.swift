//
//  ViewController.swift
//  termproject
//
//  Created by 배유진 on 2022/05/19.
//

import UIKit

class ViewController: UIViewController {

    // 스토리보드 연결
    @IBOutlet weak var dateLabel: UILabel!
    
    let thisDate = DateFormatter();
    
    override func viewDidLoad() {
        // 년-월별 표시 날짜 포멧팅
        thisDate.dateFormat = "yyyy-MM"
        let current_date_string = thisDate.string(from: Date())
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /* Start code*/
        // 디폴트 날짜 지정
        dateLabel.text = current_date_string
    }
    
    @IBAction func right_click(_ sender: Any) {
        print("Click RIGHT")
    }
    @IBAction func left_click(_ sender: Any) {
        print("Click Left")
    }
}

