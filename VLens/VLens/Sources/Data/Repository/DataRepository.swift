//
//  DataRepository.swift
//  VLensSdkSample
//
//  Created by Mohamed Taher on 05/11/2024.
//

class DataRepository {
        
    let logger: Logger
    
    init() {
        logger = Logger(className: "DataRepository")
    }
    
    func handleResponse<T>(functionName: String, data: T?, status: StatusEnum, handleApiResponse: @escaping(_ response: T?) -> Void, onFaild: @escaping (_ error: ApiResponse<String>?) -> Void) {
        
        switch status {
        case .OK:
            handleApiResponse(data)
            logger.success("\(functionName)")
            
        case .Error(let data):
            
//            if(data?.header?.status?.code == "\(HttpStatusCode.Http401_Unauthorized.rawValue)"
//               && functionName != "login(request:handleApiResponse:onFaild:)"
//               && functionName != "logout(request:handleApiResponse:onFaild:)"
//            ) {
//                handleSessionInvalid()
//                return
//            }
            
            logger.error("\(functionName) - \(data?.errorMessage ?? "No Status Returned!")")
            
            onFaild(data)
        }
    }
}

extension DataRepository {
    
    func postVerifyIdFront(request: VerifyIdFrontPost.Request, handleApiResponse: @escaping(_ response: ApiResponse<VerifyIdFrontPost.Data>?) -> Void, onFaild: @escaping (_ error: ApiResponse<String>?) -> Void) {
        logger.info("\(#function)")
        
        let service = HttpService<ApiResponse<VerifyIdFrontPost.Data>>()
        service.postData(ApiConfig.VERIFY_ID_FRONT_POST, body: request) { (_data, _status) in
            self.handleResponse(
                functionName: "\(#function)",
                data: _data,
                status: _status,
                handleApiResponse: handleApiResponse,
                onFaild: onFaild
            )
        }
    }
    
    func postVerifyIdBack(request: VerifyIdBackPost.Request, handleApiResponse: @escaping(_ response: ApiResponse<VerifyIdBackPost.Data>?) -> Void, onFaild: @escaping (_ error: ApiResponse<String>?) -> Void) {
        logger.info("\(#function)")
        
        let service = HttpService<ApiResponse<VerifyIdBackPost.Data>>()
        service.postData(ApiConfig.VERIFY_ID_BACK_POST, body: request) { (_data, _status) in
            self.handleResponse(
                functionName: "\(#function)",
                data: _data,
                status: _status,
                handleApiResponse: handleApiResponse,
                onFaild: onFaild
            )
        }
    }

    func postVerifyLivenessMulti(request: VerifyLivenessMultiPost.Request, handleApiResponse: @escaping(_ response: ApiResponse<VerifyLivenessMultiPost.Data>?) -> Void, onFaild: @escaping (_ error: ApiResponse<String>?) -> Void) {
        logger.info("\(#function)")
        
        let service = HttpService<ApiResponse<VerifyLivenessMultiPost.Data>>()
        service.postData(ApiConfig.VERIFY_LIVENESS_MULTI_POST, body: request) { (_data, _status) in
            self.handleResponse(
                functionName: "\(#function)",
                data: _data,
                status: _status,
                handleApiResponse: handleApiResponse,
                onFaild: onFaild
            )
        }
    }
    
}
