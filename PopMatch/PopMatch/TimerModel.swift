//
//  TimerModel.swift
//  PopMatch
//
//  Created by Ray Ngan on 2/25/21.
//

import Foundation

protocol TimerModelUpdates: class {
    
    func currentTimeDidChange(_ currentTime: Int)
    
}

class TimerModel {
    var startTime = 300
    var addedTime = false;
    weak var delegate: TimerModelUpdates?
    
    
    func timerNeedsUpdating() {
        startTime -= 1;
        delegate?.currentTimeDidChange(startTime)
    }
    
    func start() {
        let timer = Timer(timeInterval: 1, repeats: true) { _ in
            self.timerNeedsUpdating()
        }
        RunLoop.main.add(timer, forMode: .default)
    }
    func addTime(){
        if(!addedTime){
            startTime += 60
            addedTime = true;
        }
    }
    func getStartTime () -> Int{
        return startTime
    }
   
}
