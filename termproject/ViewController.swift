//
//  ViewController.swift
//  termproject
//
//  Created by 배유진 on 2022/05/19.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseFirestore

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
    var tableViewItems = [""]
    
    /* 데이터 베이스 접근 */
    let db = Firestore.firestore()
    
    /* ================================== */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        
        // DataSource delegete을 ViewController로 설정
        tableView.dataSource = self
        
        self.getData()
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
    func getData(){
        db.collection("account").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("ERROR GETTING DOCUMENT: \(err)")
            } else {
                print("GETTING DOCUMENT")
                guard let documents = querySnapshot?.documents else {return}
                
                for document in documents {
                    do{
                        let data = document.data()
                        print(data)
                        
//                        if(data["yearMonth"] as! String == "202206"){
//                            self.tableViewItems.append(data["content"] as! String)
//                        }
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
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
