
import UIKit
import RxSwift
import RxCocoa

protocol ScheduleCellDelegate : class {
    func handleButtonClicked(schedule:Schedule?,completion:@escaping((Bool) -> Void))
}

final class ScheduleCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let reuseIdentifier = "ScheduleCell"
    
    private var disposBag = DisposeBag()
    weak var delegate : ScheduleCellDelegate?
    
    var schedule: Schedule? {
        didSet{
            DispatchQueue.main.async {
                self.configure()
            }
        }
    }
    private var scheduleLabel = UILabel().then {
        $0.text = "프로젝트 기획서 마감"
        $0.font = .noto(size: 16, family: .Regular)
        $0.textColor = .darkGray
        $0.textAlignment = .left
    }
    
    private lazy var checkButton = UIButton().then {
        $0.setImage(UIImage(systemName: "checkmark"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.layer.masksToBounds = false
        $0.layer.borderColor = UIColor.init(named: "a1b5f5")?.cgColor
        $0.layer.borderWidth = 0.2
        $0.tintColor = .white
        $0.layer.cornerRadius = 23/2
    }
    
    //MARK: - LifeCycle
    override init(frame:CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        contentView.addSubview(scheduleLabel)
        scheduleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(checkButton)
        checkButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(23)
        }
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1.0

        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
        checkButton.rx.tap.bind {
            self.delegate?.handleButtonClicked(schedule: self.schedule) { [weak self] status in
                guard let newschedule = self?.schedule else {
                    return
                }
                let newSchedule = Schedule(categoryID: newschedule.categoryID, checkStatus: status, date: newschedule.date, id: newschedule.id, name: newschedule.name)
                self?.schedule = newSchedule
            }
        }.disposed(by: disposBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    func configure() {
        guard let schedule = schedule else {
            return
        }
        
        checkButton.backgroundColor = schedule.checkStatus ? .mainColor : .white
        scheduleLabel.attributedText = schedule.checkStatus ? schedule.name.strikeThrough() : NSAttributedString(string: schedule.name)
    }
}
