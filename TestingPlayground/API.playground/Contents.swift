import UIKit
import Alamofire
import RxSwift


var str = "Hello, playground"

AF.request("https://swapi.dev/api/films")
    .validate()
    .responseDecodable(of: Films.self) { (response) in
        guard let films = response.value else { return }
        print(films.all[0].title)
}
