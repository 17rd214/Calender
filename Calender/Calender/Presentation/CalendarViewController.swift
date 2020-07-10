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
   
    
    
  
    
    
    
    var keep_data_count = 0     //data_string(配列)の個数
    
    var empty_count = 0 //日にちを表示しない場所の数
    
    var select_days = 0 //選んだ日付
    
    var days = 0            //keep_days_goraku,nitiyouを参照するための変数(0~31まで変化)
    
    var thismonth_zankin = 0
    
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
    
    
    @IBOutlet weak var zankin: UILabel!
    
    @IBAction func prevBtn(_ sender: UIBarButtonItem) {
        prevMonth()
        set_data()  //新たにその月の保存領域を設定
        set_zankin() //月の残額表示
        days = 0   //daysリセット
        empty_count = 0 //空白日数リセット
    }
    @IBAction func nextBtn(_ sender: UIBarButtonItem) {
        nextMonth()
        set_data() //新たにその月の保存領域を設定
        set_zankin() //月の残額表示
        days = 0    //daysリセット
        empty_count = 0 //空白日数リセット
    }
    
    
    
    @IBAction func data_renew(_ sender: Any) {//更新動作
      
        
        let i = Check_data_string()  //過去にその年、月の有無確認
        
       
        
        if(i >= 0){//更新ボタンを押した年、月に入力された値が入る
            Savedata.save_string[i].keep_days_goraku[Uke.hiduke - 1] = Uke.goraku
            Savedata.save_string[i].keep_days_nitiyou[Uke.hiduke - 1] = Uke.nitiyo
            
        
            if(Uke.koteihi != 0){
            Savedata.save_string[i].koteihi = Uke.koteihi
            }
            if(Uke.income != 0){
            Savedata.save_string[i].income = Uke.income
            }
            if(Uke.special != 0){
            Savedata.save_string[i].special = Uke.special
            }
            if(Uke.shokuhi != 0){
                Savedata.save_string[i].shokuhi = Uke.shokuhi
            }
            //print(Uke.nitiyo)
        }
        set_zankin() //月の残額表示
        days = 0    //daysリセット
        empty_count = 0 //空白日数リセット
       
        commonSettingMoveMonth()
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
        //print("Viewdid")
        configure()
        settingLabel()
        getToday()
        set_data()      //保存用の領域を追加
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
        Uke.now_year = date.year1   //現在の年を記憶
        Uke.now_month = date.month1     //現在の月を記憶
    }

    
    func set_data(){//データの保存領域を追加
        //過去に同じデータがないか確認
        if(Check_data_string() >= 0){//過去にデータあり
            return
        }
        
        Savedata.save_string.append(Savedata.Datasave(keep_days_goraku: Array(repeating:0,count:31), keep_days_nitiyou: Array(repeating:0,count:31), koteihi: 0, income: 0, special: 0, shokuhi: 0, year: 0, month: 0))
        
        Savedata.save_string[keep_data_count].year = Uke.now_year
        Savedata.save_string[keep_data_count].month = Uke.now_month
        keep_data_count += 1
        print(Savedata.save_string[keep_data_count - 1].month)
        print(keep_data_count)
        
        
    }
    
    func set_zankin(){
        var total_cost = 0
        let i = Check_data_string()
        Uke.goraku = 0   //入力値リセット
        Uke.nitiyo = 0   //入力値リセット
        Uke.income = 0
        Uke.special = 0
        Uke.koteihi = 0
        Uke.shokuhi = 0
        thismonth_zankin = Savedata.save_string[i].income
        days = 0
        while(days < 31){
            total_cost += Savedata.save_string[i].keep_days_goraku[days]
            total_cost += Savedata.save_string[i].keep_days_nitiyou[days]
            
            days += 1
        }
        total_cost += Savedata.save_string[i].koteihi
        total_cost += Savedata.save_string[i].special
        total_cost += Savedata.save_string[i].shokuhi
        thismonth_zankin -= total_cost
        zankin.text = String(thismonth_zankin)
    }
    
    //過去に作られたデータがあるか確認
    func Check_data_string() ->Int {
        var i = 0
        while(i < keep_data_count  ){
            //print(i)
            //print("check")
            if(Savedata.save_string[i].year == Uke.now_year && Savedata.save_string[i].month == Uke.now_month ){
                return i  //あった場合のその場所
                
            }
             i += 1
        }
        return -1 //過去にデータがなかった
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
        Uke.now_year = moveDate.year2           //現在の年を記憶
        Uke.now_month = moveDate.month2         //現在の月を記憶
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
    //データを表示させる
    private func showDate(_ section: Int, _ row: Int, _ cell: UICollectionViewCell, _ label: UILabel) {
        switch section {
        case 0:
            label.text = dayOfWeekLabel[row]
            cell.selectedBackgroundView = nil
        default:
            if(daysArray2[row] == "" && days == 0){
                empty_count += 1
            }
            else if(daysArray2[row] != ""){
                let i = Check_data_string()
                //daysArray2に入力データを追加する
                if(i >= 0 && i < keep_data_count){
                
                daysArray2[row] = daysArray2[row] + "\n" +  String(Savedata.save_string[i].keep_days_goraku[days] + Savedata.save_string[i].keep_days_nitiyou[days])
                days += 1
                }
                
                
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
    
    // Cell が選択された場合
    func collectionView(_ collectionView: UICollectionView,
                             didSelectItemAt indexPath: IndexPath) {
    
        //var select = daysArray2[indexPath.row]
        //選んだ日付
        
         select_days = indexPath.row - empty_count
         select_days += 1
        // Inputformへ遷移するために Segue を呼び出す
        if(daysArray2[indexPath.row] != ""){
        performSegue(withIdentifier: "toInputform",sender: nil)
        }
    }
    
    // Segue 準備
       override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
           if (segue.identifier == "toInputform") {
               let If: Inputform = (segue.destination as? Inputform)!
    
               // SubViewController のselectedImgに選択された画像を設定する
               If.days_select = select_days
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
