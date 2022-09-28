import Foundation
import RxSwift

var disposeBag = DisposeBag()

enum TraitsError : Error{
    case single
    case maybe
    case completable
}

print("-SING1-")
Single<String>.just("😋")
    .subscribe {
        print($0)
    } onFailure: {
        print($0)
    } onDisposed: {
        print("onDisposed")
    }
    .disposed(by: disposeBag)

print("-SING2-")
Observable<String>.create{observer -> Disposable in
    observer.onError(TraitsError.single)
    return Disposables.create()
    }
    .asSingle()
    .subscribe {
        print($0)
    } onFailure: {
        print("\($0) ERROR!!!!!!!!!!!!!!!!!!")
    } onDisposed: {
        print("onDisposed")
    }
    .disposed(by: disposeBag)

print("-SING3-")
struct SomeJSON : Decodable{
    let name : String
}

enum JSONError : Error{
    case decodingError
}

let json = """
{"name" : "lee"}
"""

let json2 = """
{"age : 123}
"""

func decode(json: String) -> Single<SomeJSON>{
    Single<SomeJSON>.create{ observer -> Disposable in
        guard let data = json.data(using: .utf8),
              let json = try? JSONDecoder().decode(SomeJSON.self, from: data) else{
                  observer(.failure(JSONError.decodingError))
                  return Disposables.create()
              }
        observer(.success(json))
        return Disposables.create()
    }
}

decode(json: json)
    .subscribe{
        switch $0{
        case let .success(json):
            print(json)
        case let .failure(error):
            print(error)
        }
    }
    .disposed(by: disposeBag)

decode(json: json2)
    .subscribe{
        switch $0{
        case let .success(json):
            print(json)
        case let .failure(error):
            print(error)
        }
    }
.disposed(by: disposeBag)

print("-MAYBE1-")
Maybe.just("😆")
    .subscribe {
        print($0)
    } onError: {
        print($0)
    } onCompleted: {
        print("onCompleted")
    } onDisposed: {
        print("onDisposed")
    }
    .disposed(by: disposeBag)

print("-MAYBE2-")
Observable.create{ observer -> Disposable in
    observer.onError(TraitsError.maybe)
    return Disposables.create()
    }
    .asMaybe()
    .subscribe{
        print($0)
    }
    .disposed(by: disposeBag)

print("-COMPLETABLE1-")
Completable.create{ observer -> Disposable in
    observer(.error(TraitsError.completable))
    return Disposables.create()
}
.subscribe {
    print("COMPLETABLE")
} onError: {
    print("ERROR: \($0)")
} onDisposed: {
    print("onDisposed")
}
.disposed(by: disposeBag)

print("-COMPLETABLE2-")
Completable.create{ observer -> Disposable in
    observer(.completed)
    return Disposables.create()
}
.subscribe {
    print("COMPLETABLE")
} onError: {
    print("ERROR: \($0)")
} onDisposed: {
    print("onDisposed")
}
.disposed(by: disposeBag)
