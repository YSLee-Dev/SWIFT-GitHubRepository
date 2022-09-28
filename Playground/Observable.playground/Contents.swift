import Foundation
import RxSwift

print("-JUST-")
Observable<Int>.just(1)
    .subscribe(onNext: {
        print($0)
    })

print("-OF-")
Observable<Int>.of(1,2,3)
    .subscribe(onNext: {
        print($0)
    })

print("-OF2-")
Observable.of([1,2,3], [4,5,6])
    .subscribe(onNext: {
        print($0)
    })

print("-FROM-")
Observable.from([1,2,3])
    .subscribe(onNext: {
        print($0)
    })

print("-SUBSCRIBLE1-")
Observable.of(1,2,3,4,5)
    .subscribe{
        print($0)
    }

print("-SUBSCRIBLE2-")
Observable.of(1,2,3)
    .subscribe{
        if let element = $0.element {
            print(element)
        }
    }

print("-SUBSCRIBLE3-")
Observable.of(1,2,3)
    .subscribe(onNext:{
        print($0)
    })

print("-EMPTY-")
Observable<Void>.empty()
    .subscribe{
        print($0)
    }

print("-NEVER-")
Observable.never()
    .subscribe(onNext: {
        print($0)
    },onCompleted: {
        print("onCompleted0")
    })

print("-RANGE-")
Observable.range(start: 1, count: 9)
    .subscribe(onNext: {
        print($0)
    })

print("-DISPOSE-")
Observable.of(1,2,3,4,5)
    .subscribe(onNext:{
        print($0)
    })
    .dispose()

print("-DISPOSEBAG-")
let disposeBag = DisposeBag()

Observable.of(1,2,3,4,5)
    .subscribe{
        print($0)
    }
    .disposed(by: disposeBag)

print("-CREATE1-")
Observable.create{ observer -> Disposable in
    observer.onNext(1)
    observer.onCompleted()
    observer.onNext(2) // 실행 안됨
    return Disposables.create()
}
.subscribe{
    print($0)
}
.disposed(by: disposeBag)

print("-CREATE2-")
enum ohError : Error{
    case isError
}

Observable.create{ observer -> Disposable in
    observer.onNext(1)
    observer.onError(ohError.isError)
    observer.onNext(2)
    observer.onCompleted()
    return Disposables.create()
}
.subscribe{
    print($0)
}
.disposed(by: disposeBag)

print("-DEFFERED1-")
Observable.deferred{
    Observable.of(1,2,3)
}
.subscribe{
    print($0)
}

.disposed(by: disposeBag)

print("-DEFFERED2-")
var 손바닥 : Bool = false

let fatory : Observable<String> = Observable.deferred{
    손바닥 = !손바닥
    
    if 손바닥{
        return Observable.of("앞")
    }else{
        return Observable.of("뒤")
    }
}

for _ in 0...4{
    fatory.subscribe{
        print($0)
    }
}
