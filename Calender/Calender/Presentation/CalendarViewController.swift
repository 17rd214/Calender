import UIKit

//MARK:- Protocol
protocol ViewLogic {
    var numberOfWeeks: Int { get set }
    var daysArray2: [String]! { get set }
}

//MARK:- UIViewController
class CalendarViewController: UIViewController, ViewLogic{
    
    //MARK: Properties
    
    var numberOfWeeks: Int = 0
    var daysArray2: [String]!
    private var requestForCalendar: RequestForCalendar?
   
    
    struct keep_data {//入力されたデータを保存する場所(一ヶ月単位)
        var keep_days_goraku = Array(repeating:0,count:31)
        var keep_days_nitiyou  = Array(repeating:0,count:31)
        var koteihi = 0
        var year = 0
        var month = 0
    }
    
    
    var data_string = [keep_data]()     //配列作成
    
    
    
    var keep_data_count = 0     //data_string(配列)の個数
    
    
    var now_year = 0        //現在いる場所の年数
    var now_month = 0       //現在いる場所の月
    var days = 0            //keep_days_goraku,nitiyouを参照するための変数(0~31まで変化)
    
    private let date = DateItems.ThisMonth.Request()
    private let daysPerWeek = 7
    private var thisYear: Int = 0
    private var thisMonth: Int = 0
    private var today: Int = 0
    private var isToday = true
    private let dayOfWeekLabel = ["日", "月", "火", "水", "木", "金", "土"]
    private var monthCounter = 0
    
    //MARK: UI Parts
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func prevBtn(_ sender: UIBarButtonItem) {
        prevMonth()
        set_data()  
        //print("prevbtn")
        days = 0   //daysリセット
    }
    @IBAction func nextBtn(_ sender: UIBarButtonItem) {
        nextMonth()
        set_data()
        //print("nextBtn")
        days = 0    //daysリセット
    }
    
    
    
    @IBAction func data_renew(_ sender: Any) {
        let i = Check_data_string()
        
        if(i > 0){
            data_string[i].keep_days_goraku[Uke.hiduke - 1] = Uke.goraku
            data_string[i].keep_days_nitiyou[Uke.hiduke - 1] = Uke.nitiyo
            print(Uke.nitiyo)
        }       //print(data_string[i].keep_days_goraku[Uke.hiduke - 1])
        Uke.goraku = 0
        Uke.nitiyo = 0
    }
    
    //MARK: Initialize
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        dependencyInjection()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        dependencyInjection()
    }
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Viewdid")
        configure()
        settingLabel()
        getToday()
        set_data()
    }
    
    //MARK: Setting
    private func dependencyInjection() {
        let viewController = self
        let calendarController = CalendarController()
        let calendarPresenter = CalendarPresenter()
        let calendarUseCase = CalendarUseCase()
        viewController.requestForCalendar = calendarController
        calendarController.calendarLogic = calendarUseCase
        calendarUseCase.responseForCalendar = calendarPresenter
        calendarPresenter.viewLogic = viewController
    }
    
    private func configure() {
        collectionView.dataSource = self
        collectionView.delegate = self
        requestForCalendar?.requestNumberOfWeeks(request: date)
        requestForCalendar?.requestDateManager(request: date)
    }
    
    private func settingLabel() {
        title = "\(String(date.year1))年\(String(date.month1))月"
    }
    
    private func getToday() {
        thisYear = date.year1
        thisMonth = date.month1
        today = date.day1
        now_year = date.year1
        now_month = date.month1
    }

    //データテーブルを作成
    func set_data(){
        //過去に同じデータがないか確認
        if(Check_data_string() > 0){
            return
        }
        
        data_string.append(keep_data(keep_days_goraku: Array(repeating:0,count:31), keep_days_nitiyou: Array(repeating:0,count:31), koteihi: 0, year: 0, month: 0))
        
        data_string[keep_data_count].year = now_year
        data_string[keep_data_count].month = now_month
        keep_data_count += 1
        print(data_string[keep_data_count - 1].month)
        print(keep_data_count)
        if(data_string[keep_data_count - 1].month == thisMonth){
            data_string[keep_data_count - 1] = data_string[0]
            print("can")
            //remove(data_string[])
        }
    }
    
    //過去に作られたデータがあるか確認
    func Check_data_string() ->Int {
        var i = 0
        while(i < keep_data_count - 1 ){
            //print(i)
            //print("check")
           i += 1
            if(data_string[i].year == now_year && data_string[i].month == now_month ){
                return i  //あった場合のその場所
                
            }
             
        }
        return 0 //過去にデータがなかった
    }
}

//MARK:- Setting Button Items
extension CalendarViewController {
    
    private func nextMonth() {
        monthCounter += 1
        commonSettingMoveMonth()
    }
    
    private func prevMonth() {
        monthCounter -= 1
        commonSettingMoveMonth()
    }
    
    private func commonSettingMoveMonth() {
        daysArray2 = nil
        let moveDate = DateItems.MoveMonth.Request(monthCounter)
        requestForCalendar?.requestNumberOfWeeks(request: moveDate)
        requestForCalendar?.requestDateManager(request: moveDate)
        title = "\(String(moveDate.year2))年\(String(moveDate.month2))月"
        isToday = thisYear == moveDate.year2 && thisMonth == moveDate.month2 ? true : false
        collectionView.reloadData()
        now_year = moveDate.year2
        now_month = moveDate.month2
    }
    
}

//MARK:- UICollectionViewDataSource
extension CalendarViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 7 : (numberOfWeeks * daysPerWeek)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let label = cell.contentView.viewWithTag(1) as! UILabel
        label.backgroundColor = .clear
        dayOfWeekColor(label, indexPath.row, daysPerWeek)
        showDate(indexPath.section, indexPath.row, cell, label)
        return cell
    }
    
    private func dayOfWeekColor(_ label: UILabel, _ row: Int, _ daysPerWeek: Int) {
        switch row % daysPerWeek {
        case 0: label.textColor = .red
        case 6: label.textColor = .blue
        default: label.textColor = .black
        }
    }
    //データを入力し表示させる
    private func showDate(_ section: Int, _ row: Int, _ cell: UICollectionViewCell, _ label: UILabel) {
        switch section {
        case 0:
            label.text = dayOfWeekLabel[row]
            cell.selectedBackgroundView = nil
        default:
            if(daysArray2[row] != ""){
                daysArray2[row] = daysArray2[row] + "\n" +  String(data_string[Check_data_string()].keep_days_goraku[days] + data_string[Check_data_string()].keep_days_nitiyou[days])
                days += 1
            }
            label.text = daysArray2[row]
            label.numberOfLines = 0
            let selectedView = UIView()
            selectedView.backgroundColor = .mercury()
            cell.selectedBackgroundView = selectedView
            markToday(label)
            
            //print(row)
        }
    }
    
    private func markToday(_ label: UILabel) {
        if isToday, today.description == label.text {
            label.backgroundColor = .myLightRed()
        }
    }
    
}


//セルのサイズ指定
//MARK:- UICollectionViewDelegateFlowLayout
extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let weekWidth = Int(collectionView.frame.width) / daysPerWeek
        let weekHeight = weekWidth
        let dayWidth = weekWidth
        let dayHeight = (Int(collectionView.frame.height) - weekHeight) / numberOfWeeks - 20
        return indexPath.section == 0 ? CGSize(width: weekWidth, height: weekHeight) : CGSize(width: dayWidth, height: dayHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let surplus = Int(collectionView.frame.width) % daysPerWeek
        let margin = CGFloat(surplus)/2.0
        return UIEdgeInsets(top: 0.0, left: margin, bottom: 1.5, right: margin)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
