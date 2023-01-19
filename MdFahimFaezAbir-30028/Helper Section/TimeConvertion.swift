//
//  TimeConvertion.swift
//  MdFahimFaezAbir-30028
//
//  Created by Bjit on 17/1/23.
//

import Foundation
class TimeConvertion{
    static let shared = TimeConvertion()
    private init(){}
    
    func timeConvert(time: String)-> String{
        if time != " "{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let date = dateFormatter.date(from: time)
            guard let date = date else {return ""}
            let passedTimeInSecond = Date().timeIntervalSince(date)
            let minutes = round(passedTimeInSecond/60)
            if minutes > 59.0{
                let hour = round(minutes/60)
                if hour>23{
                    let day = round(hour/24)
                    return ("\(Int(day)) days ago")
                }else{
                    return ("\(Int(hour)) hours ago")
                }
                
            }else {
                return ("\(Int(minutes)) minutes ago")
            }
        }else{
            return " "
        }
    }
    func returnMinutes(time: String)-> Double{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: time)
        guard let date = date else {return 0.0}
        let passedTimeInSecond =  Date().timeIntervalSince(date)
        print(passedTimeInSecond)
        let minutes = round(passedTimeInSecond/60)
        print(minutes)
        return minutes
    }
}
