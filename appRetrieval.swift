import Foundation
/*
Functions for accessing and adding data to the database through Flask API ran in app.py
 */
class appRetrieval {
    // Retrieving all applications
    func fetchData(completion: @escaping ([JobApplication]?, Error?) -> Void) {
        if let url = URL(string: "http://127.0.0.1:5000/job_applications") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(nil, error)
                } else if let data = data {
                    do {
                        let jobApplications = try JSONDecoder().decode([JobApplication].self, from: data)
                        completion(jobApplications, nil)
                    } catch {
                        completion(nil, error)
                    }
                }
            }.resume()
        }
    }
    // Adding company from user input
    func postCompany(companyName: String, jobTitle: String, completion: @escaping (String?, Error?) -> Void) {
        let inputData: [String: String] = [
            "companyName": companyName,
            "jobTitle": jobTitle
        ]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: inputData) {
            if let url = URL(string: "http://127.0.0.1:5000/add_company") {
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = jsonData
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        completion(nil, error)
                    } else if let data = data {
                        if let responseString = String(data: data, encoding: .utf8) {
                            completion(responseString, nil)
                        } else {
                            completion(nil, NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Invalid response data"]))
                        }
                    }
                }.resume()
            } else {
                completion(nil, NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            }
        } else {
            completion(nil, NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "JSON serialization error"]))
        }
    }
}

