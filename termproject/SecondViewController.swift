
import UIKit
import FSCalendar
import Firebase
import FirebaseDatabase

protocol DocumentSerializable {
    init?(dictionary:[String:Any])
}

struct Money {
    var date: String
    var content: String
    var money: Int
    var plus: Bool
    var yearMonth: String
    
    var dictionary: [String:Any] {
        return [
            "date": date,
            "content": content,
            "money": money,
            "plus": plus,
            "yearMonth": yearMonth
        ]
    }
        
}

class SecondViewController: UIViewController {

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var content: UITextField!
    @IBOutlet weak var money: UITextField!
    
    // DB
    var ref: DatabaseReference!
    let db = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 달력의 평일 날짜 색깔
        calendar.appearance.titleDefaultColor = .black
        // 달력의 토,일 날짜 색깔
        calendar.appearance.titleWeekendColor = .red
        // 달력의 맨 위의 년도, 월의 색깔
        calendar.appearance.headerTitleColor = .systemPink
        // 달력의 요일 글자 색깔
        calendar.appearance.weekdayTextColor = .orange
        // 달력의 년월 글자 바꾸기
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        // 달력의 요일 글자 바꾸는 방법 1
        calendar.locale = Locale(identifier: "ko_KR")
        // 달력의 요일 글자 바꾸는 방법 2
        calendar.calendarWeekdayView.weekdayLabels[0].text = "일"
        calendar.calendarWeekdayView.weekdayLabels[1].text = "월"
        calendar.calendarWeekdayView.weekdayLabels[2].text = "화"
        calendar.calendarWeekdayView.weekdayLabels[3].text = "수"
        calendar.calendarWeekdayView.weekdayLabels[4].text = "목"
        calendar.calendarWeekdayView.weekdayLabels[5].text = "금"
        calendar.calendarWeekdayView.weekdayLabels[6].text = "토"
        
        // 년월에 흐릿하게 보이는 애들 없애기
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        
        // 터치 이벤트
        calendar.delegate = self
    }
    
    // 버튼 액션 추가
    @IBAction func minusBtn(_ sender: Any) {
//        let minusMoney = Money(date: dateLabel.text!, content: content.text!, money: 0, plus: false, yearMonth: "")
        
//        self.ref = db.collection("Money").document("DAY")
//            .collection("Moneys").addDocument(data: minusMoney.dictionary)
//        self.db.child("jmlee").child("key").setValue(["username": "BOO"])
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func plusBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension SecondViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateLabel.text = dateFormatter.string(from: date)
    }
}

extension Money : DocumentSerializable {
    init?(dictionary: [String: Any]){
        guard let date = dictionary["date"] as? String,
              let content = dictionary["content"] as? String,
              let money = dictionary["money"] as? Int,
              let plus = dictionary["plus"] as? Bool,
              let yearMonth = dictionary["yearMonth"] as? String
        else { return nil }
        
        self.init(date: date, content: content, money: money, plus: plus, yearMonth: yearMonth)
    }
}