//
//  ScheduleService.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/04/23.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper

struct PlanForm: Encodable {
    let date : Date
    let name : String
}

class ScheduleService {
    
    func createSchedule(goalId:Int64,_ parameters:[String:Any],completion:@escaping(Bool)-> Void){
        let header = AuthService.shared.getAuthorizationHeader()
        
        let URL = "http://3.36.130.116:9090/goals/\(goalId)/plans"
        AF.request(URL, method: .post, parameters: parameters,encoding: JSONEncoding.default,headers: header).responseJSON { response in
            switch response.result {
                
            case .failure(let error) :
                fatalError(error.localizedDescription)
            case .success(_) :
                completion(true)
            }
        }
    }
    
    func fetchSchedule(goalId:Int,completion:@escaping(Error?,[Schedule]?)-> Void) {
        let header = AuthService.shared.getAuthorizationHeader()
        
        let URL = "http://3.36.130.116:9090/goals/\(goalId)/plans"
        
        AF.request(URL,headers:header).responseData(completionHandler: { response in
            switch response.result {
                
            case .failure(let error) :
                fatalError(error.localizedDescription)
            case .success(let datas):
                do {
                    let ScheduleModels = try JSONDecoder().decode([ScheduleModel].self, from: datas)
                    
                    var schedule_Array = [Schedule]()
                    
                    for schedule in ScheduleModels {
                        schedule_Array.append(Schedule(categoryID: Int(exactly: goalId)!, checkStatus: schedule.checkStatus, date: schedule.date, id: schedule.id, name: schedule.name))
                    }
                    completion(nil,schedule_Array)
                }
                catch(let error){
                    completion(error,nil)
                }
            }
        })
        
    }
    
    func updatePlanCheckStatus(goalId:Int,planId:Int) {
        let header = AuthService.shared.getAuthorizationHeader()
        
        let URL = "http://3.36.130.116:9090/goals/\(goalId)/plans/\(planId)/check"
        
        AF.request(URL, method: .put,headers: header).validate(statusCode: 200..<300).responseData { response in
            switch response.result {
            case .failure(let error) :
                fatalError(error.localizedDescription)
            case .success(let datas):
                print(datas)
            }
        }
    }
    
    func delegatePlan(goalId:Int,planId:Int){
        let header = AuthService.shared.getAuthorizationHeader()
        
        let URL = "http://3.36.130.116:9090/goals/\(goalId)/plans/\(planId)"
        
        AF.request(URL, method: .delete,headers: header).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .failure(let error) :
                fatalError(error.localizedDescription)
            case .success(let datas):
                print(datas)
            }
        }
    }
    
    func fetchScheduleByDate(year:Int,month:Int,completion:@escaping([ScheduleByDates]?,Error?) -> Void) {
        let header = AuthService.shared.getAuthorizationHeader()
        
        guard let id = KeychainWrapper.standard.string(forKey: "id") else { return }
        
        let URL =
        "http://3.36.130.116:9090/users/\(id)/goals/plans/years/\(year)/months/\(month)"
        
        AF.request(URL,method: .get,headers: header).validate(statusCode: 200..<300).responseData { response in
            switch response.result {
            case .failure(let error) :
                fatalError(error.localizedDescription)
            case .success(let data):
                do {
                    let scheduleByDates = try JSONDecoder().decode([ScheduleByDates].self, from: data)
                    completion(scheduleByDates,nil)
                }
                catch(let error){
                    completion(nil,error)
                }
            }
            
        }
    }
}
