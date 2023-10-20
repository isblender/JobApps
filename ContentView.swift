import SwiftUI
import CoreData
struct JobApplication : Identifiable, Decodable {
    let id = UUID()
    var companyName: String
    var jobTitle: String
    enum CodingKeys: String, CodingKey {
        case companyName = "cName"
        case jobTitle = "pName"
    }
}
struct ContentView: View {
    @State private var jobCounter = 0
    @State private var jobApps: [JobApplication] = []
    @State private var isLoading = true
    @State private var imageSize: CGFloat = 250
    let appRetrieve  = appRetrieval()
    var body: some View {
        ZStack {
            if isLoading {
                // Blender splash screen while data is being fetched
                Image("BlenderLogoTrans")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: imageSize, height: imageSize)
                    .onAppear() {
                        withAnimation(.easeIn(duration: 3)) {
                            imageSize = 500
                        }
                    }
            } else {
                // Once data is loaded, display the jobs / counter
                NavigationView {
                    VStack(alignment: .leading) {
                        HStack() {
                            Text("Job Counter: \(jobCounter)")
                                .font(.largeTitle)
                                .frame(alignment: .leading)
                                .padding()
                            Spacer()
                            Button(action: {
                            }) {
                                NavigationLink(destination: addJobView(jobApps: $jobApps, jobCount: $jobCounter)) {
                                    HStack {
                                        Image(systemName: "plus")
                                            .font(.largeTitle)
                                    }
                                }
                            }
                        }
                        Spacer()
                        List(jobApps.reversed()) {
                            Text("\($0.jobTitle) at \($0.companyName)")
                                .font(.title)
                        }
                        .listStyle(.inset)
                        Spacer()
                    }
                }
                Spacer()
            }
        }
        .onAppear { // As soon as user opens app, begin fetching data
            isLoading = true
            appRetrieve.fetchData { jobApplications, error in
                if let error = error {
                    print("Error fetching data: \(error)")
                } else if let jobApplications = jobApplications {
                    self.jobApps = jobApplications
                    jobCounter = jobApps.count
                    isLoading = false
                    print("Success")
                }
            }
        }
    }
}
// Separate screen for inputting new jobs to database
struct addJobView: View {
    @Binding var jobApps: [JobApplication]
    @Binding var jobCount: Int
    @State private var compName = ""
    @State private var jTitle = ""
    let appRetrieve  = appRetrieval()
    var body: some View {
        VStack {
            TextField("Company Name", text: $compName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Job Title", text: $jTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button(action: {
                appRetrieve.postCompany(companyName: compName, jobTitle: jTitle) { response, error in
                        if let error = error {
                            // Handle the error, e.g., show an alert
                            print("Error adding company: \(error.localizedDescription)")
                        } else if let response = response {
                            // Handle the response, e.g., show a success message
                            print("Company added successfully. Response: \(response)")
                            let newCompany = JobApplication(companyName: compName, jobTitle: jTitle)
                            jobApps.append(newCompany)
                            jobCount = jobApps.count
                            compName = ""
                            jTitle = ""
                        }
                    }
            }) {
                Text("Submit")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
