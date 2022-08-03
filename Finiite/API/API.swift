//
//  API.swift
//  TestMoya
//
//  Created by Dmytro on 2/20/21.
//

import Foundation
import Moya
import RxSwift

public protocol ApiType {
    func request(_ target: TargetType) -> Single<Response>
}

final class Api: ApiType {
    
    public static var `default` = Api()
    
    private let provider: MoyaProvider<MultiTarget>

    init() {
        let loggerPlugin = NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose))
        provider = MoyaProvider<MultiTarget>(plugins: [loggerPlugin])
    }
    
    func request(_ target: TargetType) -> Single<Response> {
        return provider.rx.request(MultiTarget(target))
            .filterSuccessfulStatusCodes()
    }
}
