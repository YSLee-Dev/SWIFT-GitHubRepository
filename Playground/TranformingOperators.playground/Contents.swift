import Foundation
import RxSwift

let bag = DisposeBag()

print("-TO ARRAY-")
Observable.of("A", "B", "C")
    .toArray()
    .subscribe(onSuccess: {
        print($0)
    })
    .disposed(by: bag)

print("-MAP-")
Observable.of(Date())
    .map{ date -> String in
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    .subscribe{
        print($0)
    }
    .disposed(by: bag)

print("-FLAT MAP-")
protocol 선수{
    var 점수 : BehaviorSubject<Int> {get}
}

struct 양궁 : 선수{
    var 점수 : BehaviorSubject<Int>
}

let 한국 = 양궁(점수: BehaviorSubject<Int>(value: 10))
let 일본 = 양궁(점수: BehaviorSubject<Int>(value: 7))

let 올림픽 = PublishSubject<선수>()

올림픽
    .flatMap { 선수 in
        선수.점수
    }
    .subscribe{
        print("\($0)")
    }
    .disposed(by: bag)

올림픽
    .subscribe{
        print($0)
    }
    .disposed(by: bag)

올림픽.onNext(한국)
한국.점수.onNext(10)

올림픽.onNext(일본)
한국.점수.onNext(10)
일본.점수.onNext(9)

print("-FLAT MAP LATEST-")
struct Person {
    var name = BehaviorSubject<String>(value: "")
}

let people1 = Person(name: BehaviorSubject<String>(value: "유재석"))
let people2 = Person(name: BehaviorSubject<String>(value: "강호동"))
let people3 = Person(name: BehaviorSubject<String>(value: "강호동"))

var best = PublishSubject<Person>()

best
    .flatMapLatest{
        $0.name
    }
    .subscribe(onNext: {
        print($0)
    }, onCompleted: {
        print("END")
    })
    .disposed(by: bag)

best.onNext(people1)
people1.name.onNext("무한도전")

best.onNext(people2)
people1.name.onNext("놀면뭐하니")
people2.name.onNext("1박2일")
