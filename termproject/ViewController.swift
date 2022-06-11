//
//  ViewController.swift
//  termproject
//
//  Created by 배유진 on 2022/05/19.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {

    // 스토리보드 연결
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func addingBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "Add", sender: self)
    }
    /* ================================== */
    
    let now = Date()
    let thisDate = DateFormatter()
    
    var cal = Calendar.current
    var components = DateComponents()
    
    /* 테이블 변수 선언*/
    var tableViewItems = ["item1", "item2", "item3"]
    
    /* 데이터 베이스 접근 */
    let db = Database.database().reference()
    
    /* ================================== */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        
        // DataSource delegete을 ViewController로 설정
        tableView.dataSource = self
        
//        self.getData()
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
        dateLabel.text = thisDate.string(from: myDate!)
    }
    
    // 파이어베이스 데이터 가져오기
//    func getData(){
////        var content : String
////        var date : String
////        var money : Int
////        var plus : Bool
////        var yearMonth : String
////
////        let ref : DatabaseReference! = Database.database().reference()
////        print("REF : ", ref)
////        ref.child("account").child("key").observeSingleEvent(of: .value, with: {snapshot in
////            let value = snapshot.value as? NSDictionary
////            content = value?["content"] as String ?? "No String"
////            date = value?["date"] as String ?? ""
////            money = value?["money"] as Int ?? -1
////            plus = value?["plus"] as Bool ?? false
////            yearMonth = value?["yearMonth"] as String ?? ""
////        })
////    }
//
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        
        // 테이블 뷰 아이템 지정
        (cell.contentView.subviews[0] as! UILabel).text = tableViewItems[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewItems.count // 아이템 수 반환
    }
}
