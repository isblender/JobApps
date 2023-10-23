# jobApps
This is a simple iOS app that helps you manage and keep track of your job applications. It allows you to list and view the total number of your job applications in one convenient place. The app interfaces with a MySQL relational database hosted on AWS through a custom REST API built with Python and Flask.
### Layout
<em>The splash screen, listing, and adding pages.</em>

<table>
  <tr>
    <td><img src="https://github.com/isblender/jobApps/assets/142704958/0919e1f9-d4a9-47e1-a01c-c6bcc4f9c4af" width="300" height="500"></td>
    <td><img src="https://github.com/isblender/jobApps/assets/142704958/df9744d8-1909-4b8d-955c-0c464c4a5066" width="300" height="500"></td>
    <td><img src="https://github.com/isblender/jobApps/assets/142704958/de7a1a8c-ce4a-4eda-95b8-862afdb69661" width="300" height="500"></td>
  </tr>
</table>

### Features
- Overall count
- - Through fetching data from SQL database
- List applications
- Add job
- Remove (Coming soon)
- Sort (Coming soon)

### API
As mentioned above, the Flask API I made for the project is within app.py. If one wishes to create their own config.ini file for app.py to retrieve database information from, I included an example in config.ini.example.
