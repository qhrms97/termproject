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
    @IBOutlet weak var minusLabel: UILabel!
    @IBOutlet weak var plusLabel: UILabel!
    
    @IBAction func addingBtn(_ sender: UIButton) {
        guard let secPage = self.storyboard?
            .instantiateViewController(withIdentifier: "SecPage") as? SecondViewController else {
            return
        }
        
        secPage.modalPresentationStyle = .fullScreen
        self.present(secPage, animated: true)
        
//        performSegue(withIdentifier: "Add", sender: self)
    }
    /* ================================== */
    
    let now = Date()
    let thisDate = DateFormatter()
    
    var cal = Calendar.current
    var components = DateComponents()
    
    /* 테이블 변수 선언*/
    var tableViewItems : [String] = []
    var tableViewItems2 : [String] = []
    var tableViewItems3 : [Int] = []
    
    /* 데이터 베이스 접근 */
    let db = Firestore.firestore()
    
    // 빈 딕셔너리 생성
    var data: [String:Any] = [:]
    var data_plus : [String:Any] = [:]
    var data_minus : [String:Any] = [:]
    
    // 수입 지출
    var plusItems : [Int] = []
    var minusItems : [Int] = []
    
    // 총 수입 지출
    var plustotal : Int = 0
    var minustotal : Int = 0
    
    /* ================================== */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        
        // DataSource delegete을 ViewController로 설정
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        /* 변수 초기화 */
        self.tableViewItems = []
        self.tableViewItems2 = []
        self.tableViewItems3 = []
        self.minusItems = []
        self.minustotal = 0
        self.plusItems = []
        self.plustotal = 0
        
        
        self.getData()
        
        self.getplus()
        self.getminus()
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
        db.collection("account").order(by: "date", descending: true).getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("ERROR GETTING DOCUMENT #1 : \(err)")
            } else {
                print("GETTING DOCUMENT #1 ")
                guard let documents = querySnapshot?.documents else {return}
                
                for document in documents {
                    do{
                        self.data = document.data()
                        
                        self.tableViewItems.append(self.data["date"] as! String)
                        self.tableViewItems2.append(self.data["content"] as! String)
                        self.tableViewItems3.append(self.data["money"] as! Int)
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func getplus(){
        db.collection("account").whereField("plus", isEqualTo: true).getDocuments() {
            (querySnapshot, err) in
            if let err = err {
                print("ERROR GETTING DOCUMENT #2 : \(err)")
            } else {
                print("GETTING DOCUMENT #2")
                
                guard let documents = querySnapshot?.documents else {return}
                
                for document in documents {
                    do{
                        self.data_plus = document.data()
//                        print("PLUS ITEMS ", self.data_plus)
                        self.plusItems.append(self.data_plus["money"] as! Int)
                    }
                }
                print("self plusitems " ,self.plusItems)
                
                for plusItem in self.plusItems {
                    do{
                        self.plustotal += plusItem
                    }
                }
                
                self.plusLabel.text = String(self.plustotal)
            }
        }
    }
    
    func getminus(){
        db.collection("account").whereField("plus", isEqualTo: false).getDocuments() {
            (querySnapshot, err) in
            if let err = err {
                print("ERROR GETTING DOCUMENT #3 : \(err)")
            } else {
                print("GETTING DOCUMENT #3")
                
                guard let documents = querySnapshot?.documents else {return}
                
                for document in documents {
                    do{
                        self.data_minus = document.data()
//                        print("MINUS ITEMS ", self.data_minus)
                        self.minusItems.append(self.data_minus["money"] as! Int)
                    }
                }
                print("self minus items " , self.minusItems)
                
                for minusItem in self.minusItems {
                    do{
                        self.minustotal += minusItem
                    }
                }
                
                self.minusLabel.text = String(self.minustotal)
            }
        }
    }
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        
        // 테이블 뷰 아이템 지정
        (cell.contentView.subviews[0] as! UILabel).text = tableViewItems[indexPath.row]
        (cell.contentView.subviews[1] as! UILabel).text = tableViewItems2[indexPath.row]
        (cell.contentView.subviews[2] as! UILabel).text = String(tableViewItems3[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tableViewItems.count // 아이템 수 반환
        return self.tableViewItems.count // 아이템 수 반환
    }
}
