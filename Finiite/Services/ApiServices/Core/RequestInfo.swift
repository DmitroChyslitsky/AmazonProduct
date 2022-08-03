enum ResponseStatusCode: Int {
    case success = 200
    case created = 201
    case accepted = 202
    case noContent = 204
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case requestTimeOut = 408
    case unprocessable = 422
    case internalServerError = 500
    case notImplemented = 501
    case unknown = 999
}

enum RequestHTTPMethod: String {
    /// `CONNECT` method.
    case connect = "CONNECT"
    /// `DELETE` method.
    case delete = "DELETE"
    /// `GET` method.
    case get = "GET"
    /// `HEAD` method.
    case head = "HEAD"
    /// `OPTIONS` method.
    case options = "OPTIONS"
    /// `PATCH` method.
    case patch = "PATCH"
    /// `POST` method.
    case post = "POST"
    /// `PUT` method.
    case put = "PUT"
}

enum RequestParameterEncoding {
    case url
    case json
}

class RequestInfoFactory {
    static var accessToken = ""
    static let rootURL = "http://44.193.122.180/"
    static let mainURL = "http://44.193.122.180/api/"
    static let checkSubscriptionURL = mainURL + "subscription/check"
    static let saveUserURL = mainURL + "user"
    static let subscriptionURL = mainURL + "subscription"
    static let updateCount = mainURL + "subscription/update_use"

    /// Generate an default header with accept and content type
    /// create header for request
    /// - Parameter accessToken: access token
    /// - Returns: header configed
    static func defaultHeader() -> [String: String] {
        return [
            "Authorization": "Bearer \(accessToken)",
            "Accept": "application/json"
        ]
    }
}

struct RequestInfo {
    var requestType: RequestHTTPMethod
    var header: [String: String] = [:]
    var body: [String: Any] = [:]
    var encoding: RequestParameterEncoding = .url
}
