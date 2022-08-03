import Foundation
import SwiftyJSON

class AppService {
    private var requestService: GradingHttpServiceable? {
        return GradingRequestService()
    }
    
    func saveUserInfo(userName: String, userEmail: String, callBack: @escaping (_ json: JSON) -> ()) {
        let url = RequestInfoFactory.saveUserURL
        let param: [String: String] = [
            "fullName": userName,
            "email": userEmail
        ]
        let requestInfo = RequestInfo(requestType: .post, header: RequestInfoFactory.defaultHeader(), body: param)
        requestService?.makeRequest(to: url, withRequestInfo: requestInfo){(reponse, serverData, json) in
            callBack(json)
        }
    }
    
    func checkSubscription(userEmail: String, callBack: @escaping (_ json: JSON) -> ()) {
        let url = RequestInfoFactory.checkSubscriptionURL
        let param: [String: String] = [
            "email": userEmail
//            "month": userEmail,
//            "year": userEmail
        ]
        let requestInfo = RequestInfo(requestType: .get, header: RequestInfoFactory.defaultHeader(), body: param)
        requestService?.makeRequest(to: url, withRequestInfo: requestInfo){(reponse, serverData, json) in
            callBack(json)
        }
    }
    
    func subscription(userEmail: String, callBack: @escaping (_ json: JSON) -> ()) {
        let url = RequestInfoFactory.subscriptionURL
        let param: [String: String] = [
            "email": userEmail
//            "month": userEmail,
//            "year": userEmail
        ]
        let requestInfo = RequestInfo(requestType: .post, header: RequestInfoFactory.defaultHeader(), body: param)
        requestService?.makeRequest(to: url, withRequestInfo: requestInfo){(reponse, serverData, json) in
            callBack(json)
        }
    }

    func updateCount(userEmail: String, callBack: @escaping (_ json: JSON) -> ()) {
        let url = RequestInfoFactory.updateCount
        let param: [String: String] = [
            "email": userEmail
//            "month": userEmail,
//            "year": userEmail
        ]
        let requestInfo = RequestInfo(requestType: .post, header: RequestInfoFactory.defaultHeader(), body: param)
        requestService?.makeRequest(to: url, withRequestInfo: requestInfo){(reponse, serverData, json) in
            callBack(json)
        }
    }
}
