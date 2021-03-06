//
//  GoalViewCell.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/04/27.
//

import UIKit

final class GoalViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    var goal: Goal? {
        didSet{
            configure()
        }
    }
    static let reuseIdentifier = "GoalViewCell"
    
    private var circleProgressBar = CircleProgressBar(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    private var iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "plus")
        $0.backgroundColor = .clear
        $0.tintColor = .white
    }
    private var titleLabel = UILabel().then {
        $0.text = "목표"
        $0.font = .noto(size: 16, family: .Regular)
        $0.textColor = .white
    }
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Cofigure
    func configure() {
        guard let goal = goal else { return }
        guard let schedule = goal.schedules else { return }
        contentView.backgroundColor = .brown
        contentView.backgroundColor = UIColor.init(hex: goal.color)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.iconImageView.image = UIImage(named:goal.icon)
            self.titleLabel.text = goal.title
            self.circleProgressBar.percent = Double(Double(goal.doneSchedule) / Double(schedule.count))
        }
        
    }
    
    func configureUI(){
        
        contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(20)
            make.width.height.equalTo(40)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(iconImageView.snp.bottom).offset(15)
        }
        
        contentView.addSubview(circleProgressBar)
        circleProgressBar.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        contentView.layer.masksToBounds = false
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowOffset = CGSize(width: -2, height: 2)
        contentView.layer.cornerRadius = 20
        contentView.layer.shadowColor = UIColor.black.cgColor
        
    }
    
}
