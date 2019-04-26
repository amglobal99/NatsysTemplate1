//
//  DelayedWorkScheduler.swift
//  NatsysTemplate1
//
//  Created by amglobal on 4/26/19.
//  Copyright © 2019 Natsys. All rights reserved.
//

import Foundation

protocol WorkType: Hashable {
    var work: ()->Void { get }
}

struct WorkItem<Work: WorkType>: Hashable {
    
    let dispatchWorkItem: DispatchWorkItem
    let hashValue: Int
    
    //TODO: fix
    func hash(into hasher: inout Hasher) {
        hasher.combine(-1)
    }
    
    static func ==(lhs: WorkItem<Work>, rhs: WorkItem<Work>) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    init(work: Work) {
        hashValue = work.hashValue
        dispatchWorkItem = DispatchWorkItem {
            work.work()
        }
    }
    
    func schedule(withDelay delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: dispatchWorkItem)
    }
    
    func cancel() {
        dispatchWorkItem.cancel()
    }
}

struct DelayedWorkScheduler<Work: WorkType> {
    private var workItems: Set<WorkItem<Work>> = []
    
    private mutating func schedule(workItem: WorkItem<Work>, withDelay delay: Double) {
        workItems.update(with: workItem)?.cancel()
        workItem.schedule(withDelay: delay)
    }
    
    mutating func schedule(work: Work, withDelay delay: Double) {
        let workItem = WorkItem(work: work)
        schedule(workItem: workItem, withDelay: delay)
    }
}
