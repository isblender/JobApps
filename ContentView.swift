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
let topBackground = LinearGradient(
    gradient: Gradient(colors: [Color(hex: 0x7785AC), Color(hex: 0x9AC6C5)]),
    startPoint: .leading,
    endPoint: .trailing
)

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
                    VStack(alignment: .center) {
                        HStack() {
                            Text("Job Count: \(jobCounter)")
                                .font(.largeTitle)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Spacer()
                            Button(action: {
                            }) {
                                NavigationLink(destination: addJobView(jobApps: $jobApps, jobCount: $jobCounter)) {
                                    HStack {
                                        Image(systemName: "plus")
                                            .font(.title)
                                            .padding(12)
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                        
                                    }
                                }
                            }
                        }
                        .background(topBackground)
                        Spacer()
                        List(jobApps.reversed()) { job in
                            VStack(alignment: .leading) {
                                Text(job.companyName)
                                    .font(.title)
                                Text(job.jobTitle)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                            .padding(.vertical, 4)
                        }
                        .listStyle(.inset)
                        Spacer()
                    }
                }
                .padding(.bottom)
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
            TextField("Job Title", text: $jTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color(white: 0.75))
                .padding()
            TextField("Company Name", text: $compName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color(white: 0.75))
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
extension Color {
    init(hex: UInt) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0
        )
    }
}
