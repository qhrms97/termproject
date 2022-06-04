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
    
    let now = Date()
    let thisDate = DateFormatter()
    
    var cal = Calendar.current
    var components = DateComponents()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    private func initView(){
        // 년-월별 표시 날짜 포멧팅
        thisDate.dateFormat = "yyyy-MM"
        
        components.year = cal.component(.year, from: now)
        components.month = cal.component(.month, from: now)
        components.day = 1
        
        /* Start code*/
        // 디폴트 날짜 지정
        self.DateCollection()
    }
    
    @IBAction func right_click(_ sender: Any) {
        components.month = components.month! + 1
        self.DateCollection()
    }
    @IBAction func left_click(_ sender: Any) {
        components.month = components.month! - 1
        self.DateCollection()
    }
    
    // 날짜 변동 함수...? 따로 만들어야함
    func DateCollection(){
        let myDate = cal.date(from: components)
        // dateLabel.text = current_date_string
        dateLabel.text = thisDate.string(from: myDate!)
    }
}

