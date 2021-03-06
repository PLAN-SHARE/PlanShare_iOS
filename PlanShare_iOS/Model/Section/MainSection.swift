//
//  MainSection.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/03/18.
//

import Foundation
import Differentiator

enum SectionItem {
    case following(member: Member)
    case schedule(schedule: Schedule)
}

enum SectionModel: SectionModelType {
    
    typealias item = SectionItem
    
    case FollowingModel(items: [SectionItem])
    case ScheduleModel(header: Int, items: [SectionItem])
    case ScheduleEmptyModel(header: Int = 0,items: [SectionItem])
    
    var items: [SectionItem] {
        switch self {
        case .FollowingModel(items: let items) :
            return items.map{$0}
        case .ScheduleModel(header: _, items: let items) :
            return items.map{$0}
        case .ScheduleEmptyModel(header: _, items: let items) :
            return items
        }
    
    }
    
    init(original: SectionModel, items: [SectionItem]) {
        switch original {
        case .FollowingModel(let items):
            self = .FollowingModel(items: items)
        case .ScheduleModel(let header, let items):
            self = .ScheduleModel(header: header, items: items)
        case .ScheduleEmptyModel(header: let header, items: let items):
            self = .ScheduleEmptyModel(header: header, items: items)
        }
    }
    
}
