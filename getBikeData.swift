import Alamofire

Alamofire.request(.GET, "https://feeds.citibikenyc.com/stations/stations.json", parameters: [])
         .response { request, response, data, error in
              print(request)
              print(response)
              print(error)
          }



