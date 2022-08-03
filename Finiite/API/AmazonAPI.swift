//
//  AmazonAPI.swift
//  TestMoya
//
//  Created by Dmytro on 2/20/21.
//

import Foundation
import UIKit
import Moya

public enum UploadPhotoAPI {
    case uploadImage(String)
}

extension UploadPhotoAPI: TargetType {
    
    public var method: Moya.Method {
        switch self {
        case .uploadImage(_):
            return .post
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .uploadImage(let imageURL):
            return .requestData(Data(imageURL.utf8))
        }
    }
    
    
    public var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    public var baseURL: URL {
        guard let url = URL(string: "http://ec2-18-235-39-24.compute-1.amazonaws.com:5000/") else {
            fatalError("baseURL could not be configured.")
        }
        return url
    }
    
    public var path: String {
        switch self {
        case .uploadImage(_):
            return "api/model/skin-seg/invoke"
        }
    }
}

public protocol RainforestApiType: TargetType {
    var apiKey: String { get }
}

public enum RainforestApi: RainforestApiType {
    
    public var apiKey: String {
        return "1DF5D2A4C2E1427C937E26FC738EFB6D"
    }
    
    case getProduct(url: String)
}

extension RainforestApi {

    public var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .getProduct(url: let url):
            return .requestParameters(parameters: ["url": url], encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    public var baseURL: URL {
        // guard let url = URL(string: "https://api.rainforestapi.com/request?api_key=\(apiKey)&type=bestsellers") else {

        guard let url = URL(string: "https://api.rainforestapi.com/request?api_key=\(apiKey)&type=search") else {
            fatalError("baseURL could not be configured.")
        }
        return url
    }
    
    public var path: String {
        switch self {
        default:
            return ""
        }
    }
}
