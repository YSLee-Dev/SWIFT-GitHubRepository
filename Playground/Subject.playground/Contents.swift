import Foundation
import RxSwift

let bag = DisposeBag()

print("-PUBLISH SUBJECT-")
let publishSubject = PublishSubject<String>()
publishSubject.onNext("1. 여러분 안녕하세요.")

let 구독자1 = publishSubject
    .subscribe {
        print("PUBLISH 1: \($0)")
    }

publishSubject.onNext("2. WHO ARE YOU")
publishSubject.onNext("3. !?!?!?!?")

구독자1.dispose()

let 구독자2 = publishSubject
    .subscribe{
        print("PUBLISH 2: \($0)")
    }

publishSubject.onNext("4. I'm YOON")
publishSubject.onCompleted()
publishSubject.onNext("5. OK?")

구독자2.dispose()

publishSubject
    .subscribe{
        print("PUBLISH 3: \($0)")
    }
    .disposed(by: bag)
publishSubject.onNext("6. 나올까?")

print("-BEHAVIOR SUBJECT-")
enum SubjectError : Error{
    case error1
}

let behaviorSubject = BehaviorSubject<String>(value: "0. 초기값")
behaviorSubject.onNext("1. 첫번째야아아")

behaviorSubject.subscribe{
    print("BEHAVIOR SUBJECT 1: \($0)")
}
.disposed(by: bag)

// behaviorSubject.onError(SubjectError.error1)

behaviorSubject.subscribe{
    print("BEHAVIOR SUBJECT 2: \($0)")
}
.disposed(by: bag)

let value = try? behaviorSubject.value()
print(value)

print("-REPLAY SUBJECT-")
let replaySubject = ReplaySubject<String>.create(bufferSize: 2)

replaySubject.onNext("1. 初め")
replaySubject.onNext("２. 二つ")
replaySubject.onNext("3. 三つ")

replaySubject.subscribe{
    print("REPLAY SUBJECT 1: \($0)")
}
.disposed(by: bag)

replaySubject.subscribe{
    print("REPLAY SUBJECT 2: \($0)")
}
.disposed(by: bag)

replaySubject.onNext("4.四つ")

replaySubject.onError(SubjectError.error1)
replaySubject.dispose()

replaySubject.subscribe{
    print("REPLAY SUBJECT 3: \($0)")
}
.disposed(by: bag)
