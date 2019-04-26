//
//  PinkyPromise.swift
//  NatsysTemplate1
//
//  Created by amglobal on 4/26/19.
//  Copyright © 2019 Natsys. All rights reserved.
//

import Foundation
import PinkyPromise




//TODO MFB: move any extensions with CBL error types to CBL module?
extension Promise {
   
    
    public func then<U>(_ transform: @escaping (Value) -> Promise<U>) -> Promise<U> {
        return flatMap(transform)
    }
    
    public func then<U>(_ transform: @escaping (Value) -> U) -> Promise<U> {
        return map(transform)
    }
    
    public func always(_ resultTask: @escaping () -> Void) -> Promise<Value> {
        return onResult { _ in resultTask() }
    }
}

public func firstly<U>(_ body: () -> Promise<U>) -> Promise<U> {
    return body()
}

/// Returns a promise that asynchronously waits some number of seconds before fulfilling its task
//public func after(seconds: Double) -> Promise<Void> {
//    return Promise { (fulfill: @escaping (PinkyPromise.Result<Void>) -> ()) in
//        dispatch_after(seconds) {
//            fulfill(.success(()))
//        }
//    }
//}



// Produces a promise that runs four promises simultaneously and unifies their result.
public func zip<A, B, C, D, E>(_ resultA: PinkyPromise.Result<A>, _ resultB: PinkyPromise.Result<B>, _ resultC: PinkyPromise.Result<C>, _ resultD: PinkyPromise.Result<D>,  _ resultE: PinkyPromise.Result<E>) -> PinkyPromise.Result<(A, B, C, D, E)> {
    return zip(resultA, resultB, resultC, resultD).tryMap { a, b, c, d in
        (a, b, c, d, try resultE.value())
    }
}

public func zip<A, B, C, D, E>(_ promiseA: Promise<A>, _ promiseB: Promise<B>,  _ promiseC: Promise<C>, _ promiseD: Promise<D>,  _ promiseE: Promise<E>) -> Promise<(A, B, C, D, E)>
{
    return Promise<(A, B, C, D, E)>(task: { fulfill in
        let group = DispatchGroup()
        
        var resultA: PinkyPromise.Result<A>!
        var resultB: PinkyPromise.Result<B>!
        var resultC: PinkyPromise.Result<C>!
        var resultD: PinkyPromise.Result<D>!
        var resultE: PinkyPromise.Result<E>!
        
        promiseA.inDispatchGroup(group).call { result in
            resultA = result
        }
        
        promiseB.inDispatchGroup(group).call { result in
            resultB = result
        }
        
        promiseC.inDispatchGroup(group).call { result in
            resultC = result
        }
        
        promiseD.inDispatchGroup(group).call { result in
            resultD = result
        }
        
        promiseE.inDispatchGroup(group).call { result in
            resultE = result
        }
        
        group.notify(queue: DispatchQueue.main) {
            fulfill(zip(resultA, resultB, resultC, resultD, resultE))
        }
    })
    
}


// Produces a promise that runs five promises simultaneously and unifies their result.
public func zip<A, B, C, D, E, F>(_ resultA: PinkyPromise.Result<A>, _ resultB: PinkyPromise.Result<B>, _ resultC: PinkyPromise.Result<C>, _ resultD: PinkyPromise.Result<D>,  _ resultE: PinkyPromise.Result<E>, _ resultF: PinkyPromise.Result<F> ) -> PinkyPromise.Result<(A, B, C, D, E, F)> {
    return zip(resultA, resultB, resultC, resultD, resultE).tryMap { a, b, c, d, e in
        (a, b, c, d, e, try resultF.value())
    }
}

public func zip<A, B, C, D, E, F>(_ promiseA: Promise<A>, _ promiseB: Promise<B>,  _ promiseC: Promise<C>, _ promiseD: Promise<D>,  _ promiseE: Promise<E>, _ promiseF: Promise<F>  ) -> Promise<(A, B, C, D, E, F)>
{
    return Promise<(A, B, C, D, E, F)>(task: { fulfill in
        let group = DispatchGroup()
        
        var resultA: PinkyPromise.Result<A>!
        var resultB: PinkyPromise.Result<B>!
        var resultC: PinkyPromise.Result<C>!
        var resultD: PinkyPromise.Result<D>!
        var resultE: PinkyPromise.Result<E>!
        var resultF: PinkyPromise.Result<F>!
        
        promiseA.inDispatchGroup(group).call { result in
            resultA = result
        }
        
        promiseB.inDispatchGroup(group).call { result in
            resultB = result
        }
        
        promiseC.inDispatchGroup(group).call { result in
            resultC = result
        }
        
        promiseD.inDispatchGroup(group).call { result in
            resultD = result
        }
        
        promiseE.inDispatchGroup(group).call { result in
            resultE = result
        }
        
        promiseF.inDispatchGroup(group).call { result in
            resultF = result
        }
        
        group.notify(queue: DispatchQueue.main) {
            fulfill(zip(resultA, resultB, resultC, resultD, resultE, resultF))
        }
    })
    
}

// Produces a promise that runs seven promises simultaneously and unifies their result.
public func zip<A, B, C, D, E, F, G>(_ resultA: PinkyPromise.Result<A>, _ resultB: PinkyPromise.Result<B>, _ resultC: PinkyPromise.Result<C>, _ resultD: PinkyPromise.Result<D>,  _ resultE: PinkyPromise.Result<E>, _ resultF: PinkyPromise.Result<F>, _ resultG: PinkyPromise.Result<G> ) -> PinkyPromise.Result<(A, B, C, D, E, F, G)> {
    return zip(resultA, resultB, resultC, resultD, resultE, resultF).tryMap { a, b, c, d, e, f in
        (a, b, c, d, e, f, try resultG.value())
    }
}

// Produces a promise that runs eight promises simultaneously and unifies their result.
public func zip<A, B, C, D, E, F, G, H>(_ resultA: PinkyPromise.Result<A>, _ resultB: PinkyPromise.Result<B>, _ resultC: PinkyPromise.Result<C>, _ resultD: PinkyPromise.Result<D>,  _ resultE: PinkyPromise.Result<E>, _ resultF: PinkyPromise.Result<F>, _ resultG: PinkyPromise.Result<G>, _ resultH: PinkyPromise.Result<H> ) -> PinkyPromise.Result<(A, B, C, D, E, F, G, H)> {
    return zip(resultA, resultB, resultC, resultD, resultE, resultF, resultG).tryMap { a, b, c, d, e, f, g in
        (a, b, c, d, e, f, g, try resultH.value())
    }
}

public func zip<A, B, C, D, E, F, G>(_ promiseA: Promise<A>, _ promiseB: Promise<B>,  _ promiseC: Promise<C>, _ promiseD: Promise<D>,  _ promiseE: Promise<E>, _ promiseF: Promise<F>, _ promiseG: Promise<G>  ) -> Promise<(A, B, C, D, E, F, G)>
{
    return Promise<(A, B, C, D, E, F, G)>(task: { fulfill in
        let group = DispatchGroup()
        
        var resultA: PinkyPromise.Result<A>!
        var resultB: PinkyPromise.Result<B>!
        var resultC: PinkyPromise.Result<C>!
        var resultD: PinkyPromise.Result<D>!
        var resultE: PinkyPromise.Result<E>!
        var resultF: PinkyPromise.Result<F>!
        var resultG: PinkyPromise.Result<G>!
        
        promiseA.inDispatchGroup(group).call { result in
            resultA = result
        }
        
        promiseB.inDispatchGroup(group).call { result in
            resultB = result
        }
        
        promiseC.inDispatchGroup(group).call { result in
            resultC = result
        }
        
        promiseD.inDispatchGroup(group).call { result in
            resultD = result
        }
        
        promiseE.inDispatchGroup(group).call { result in
            resultE = result
        }
        
        promiseF.inDispatchGroup(group).call { result in
            resultF = result
        }
        
        promiseG.inDispatchGroup(group).call { result in
            resultG = result
        }
        
        group.notify(queue: DispatchQueue.main) {
            fulfill(zip(resultA, resultB, resultC, resultD, resultE, resultF, resultG))
        }
    })
    
}

public func zip<A, B, C, D, E, F, G, H>(_ promiseA: Promise<A>, _ promiseB: Promise<B>,  _ promiseC: Promise<C>, _ promiseD: Promise<D>,  _ promiseE: Promise<E>, _ promiseF: Promise<F>, _ promiseG: Promise<G>, _ promiseH: Promise<H>  ) -> Promise<(A, B, C, D, E, F, G, H)>
{
    return Promise<(A, B, C, D, E, F, G, H)>(task: { fulfill in
        let group = DispatchGroup()
        
        var resultA: PinkyPromise.Result<A>!
        var resultB: PinkyPromise.Result<B>!
        var resultC: PinkyPromise.Result<C>!
        var resultD: PinkyPromise.Result<D>!
        var resultE: PinkyPromise.Result<E>!
        var resultF: PinkyPromise.Result<F>!
        var resultG: PinkyPromise.Result<G>!
        var resultH: PinkyPromise.Result<H>!
        
        promiseA.inDispatchGroup(group).call { result in
            resultA = result
        }
        
        promiseB.inDispatchGroup(group).call { result in
            resultB = result
        }
        
        promiseC.inDispatchGroup(group).call { result in
            resultC = result
        }
        
        promiseD.inDispatchGroup(group).call { result in
            resultD = result
        }
        
        promiseE.inDispatchGroup(group).call { result in
            resultE = result
        }
        
        promiseF.inDispatchGroup(group).call { result in
            resultF = result
        }
        
        promiseG.inDispatchGroup(group).call { result in
            resultG = result
        }
        
        promiseH.inDispatchGroup(group).call { result in
            resultH = result
        }
        
        group.notify(queue: DispatchQueue.main) {
            fulfill(zip(resultA, resultB, resultC, resultD, resultE, resultF, resultG, resultH))
        }
    })
    
}

// Produces a promise that runs nine promises simultaneously and unifies their result.
public func zip<A, B, C, D, E, F, G, H, I>(_ resultA: PinkyPromise.Result<A>, _ resultB: PinkyPromise.Result<B>,
                                           _ resultC: PinkyPromise.Result<C>, _ resultD: PinkyPromise.Result<D>,
                                           _ resultE: PinkyPromise.Result<E>, _ resultF: PinkyPromise.Result<F>,
                                           _ resultG: PinkyPromise.Result<G>, _ resultH: PinkyPromise.Result<H>,
                                           _ resultI: PinkyPromise.Result<I> ) -> PinkyPromise.Result<(A, B, C, D, E, F, G, H, I)> {
    return zip(resultA, resultB, resultC, resultD, resultE, resultF, resultG, resultH).tryMap { a, b, c, d, e, f, g, h in
        (a, b, c, d, e, f, g, h, try resultI.value())
    }
}

public func zip<A, B, C, D, E, F, G, H, I>(_ promiseA: Promise<A>, _ promiseB: Promise<B>,  _ promiseC: Promise<C>, _ promiseD: Promise<D>,  _ promiseE: Promise<E>, _ promiseF: Promise<F>, _ promiseG: Promise<G>, _ promiseH: Promise<H>, _ promiseI: Promise<I>  ) -> Promise<(A, B, C, D, E, F, G, H, I)>
{
    return Promise<(A, B, C, D, E, F, G, H, I)>(task: { fulfill in
        let group = DispatchGroup()
        
        var resultA: PinkyPromise.Result<A>!
        var resultB: PinkyPromise.Result<B>!
        var resultC: PinkyPromise.Result<C>!
        var resultD: PinkyPromise.Result<D>!
        var resultE: PinkyPromise.Result<E>!
        var resultF: PinkyPromise.Result<F>!
        var resultG: PinkyPromise.Result<G>!
        var resultH: PinkyPromise.Result<H>!
        var resultI: PinkyPromise.Result<I>!
        
        promiseA.inDispatchGroup(group).call { result in
            resultA = result
        }
        
        promiseB.inDispatchGroup(group).call { result in
            resultB = result
        }
        
        promiseC.inDispatchGroup(group).call { result in
            resultC = result
        }
        
        promiseD.inDispatchGroup(group).call { result in
            resultD = result
        }
        
        promiseE.inDispatchGroup(group).call { result in
            resultE = result
        }
        
        promiseF.inDispatchGroup(group).call { result in
            resultF = result
        }
        
        promiseG.inDispatchGroup(group).call { result in
            resultG = result
        }
        
        promiseH.inDispatchGroup(group).call { result in
            resultH = result
        }
        
        promiseI.inDispatchGroup(group).call { result in
            resultI = result
        }
        
        group.notify(queue: DispatchQueue.main) {
            fulfill(zip(resultA, resultB, resultC, resultD, resultE, resultF, resultG, resultH, resultI))
        }
    })
    
}





