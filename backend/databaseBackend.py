# from flask import Flask, request, jsonify
# import firebase_admin
# from firebase_admin import credentials, firestore, storage

# # Initialize Flask app
# app = Flask(__name__)

# # Initialize Firebase Admin SDK
# cred = credentials.Certificate('/Users/prajwal/Personal/College/Sem7/MinorProject/main/backend/credetialsCertificate.json')  # Replace with your actual service account key path
# firebase_admin.initialize_app(cred, {
#     'storageBucket': 'gs://gsfcu-lms.appspot.com'  # Replace with your actual storage bucket
# })

# # Initialize Firestore and Storage
# db = firestore.client()
# bucket = storage.bucket('gsfcu-lms.appspot.com')

# @app.route('/upload', methods=['POST'])
# #Upload Videos
# def upload_video():
#     if request.method== 'POST' :
#         video = request.files['video']
#         title = request.form['title']
#         category = request.form['category']
        
#         print("All data received")
        
#         # Define the file path in Firebase Storage
#         file_name = f"{category}/{title}.mp4"#Here instead of video.filename I will replace it with title
#         print("Defined the name of the file")

#         # Upload the video to Firebase Storage
#         blob = bucket.blob(file_name)
#         # blob.upload_from_file(video.read(), content_type= video.content_type,timeout= 1200) #Timeout for 1200 sec or 20min
#         blob.upload_from_file(video, content_type= video.content_type, timeout= 1200)
#         print("Uploading completed")

#         # Get the URL of the uploaded video
#         video_url = blob.public_url
#         print("Stored in videos collection")

#         # Save video metadata to Firestore in the 'VideoLectures' collection
#         video_data = {
#             'title': title,
#             'category': category,
#             'video_url': video_url
#         }
#         print("Created the dictionary or JSON file")

#         # Adding the metadata to Firestore under the 'VideoLectures' collection
#         db.collection('VideoLectures').add(video_data)  # Use .add() for Firestore

#         # Returning the success response
#         return jsonify({"message": "Video uploaded and metadata saved successfully", "video_url": video_url})

# #get all videos
# @app.route('/getAllVideos', methods=['GET'])
# def getAllLectures():
#     #Fetching all the info from the VideoLectures collection
#     video_reference= db.collection('VideoLectures').stream()
#     videoList= []
#     for doc in video_reference:
#         video_data= doc.to_dict()

#         videoList.append({
#             'title': video_data.get('title'),
#             'category': video_data.get('category'),
#             'video_url': video_data.get('video_url'),
#         })
    
#     print(videoList)
#     return jsonify(videoList)

#     #Create a list of video lectures data from firestore
#     print("List of videos is: ")
#     print(videos)
#     print(jsonify(videoList))
#     return "Success"

# #get lectures of a particular subject
# @app.route('/getLectures', methods=['GET'])
# def getLectures():
#     #Yet to be completed
#     category= request.args.get("category")
#     print("Value of category is ",category)

#     videoReference= db.collection('VideoLectures').where("category","==", category).stream()
    
#     #Create a list of video lectures
#     videoList= []
#     for doc in videoReference:
#         video_data= doc.to_dict()
#         videoList.append({
#             'title': video_data.get('title'),
#             'category':video_data.get('category'),#Instead of this we can simply write the category
#             'video_url':video_data.get('video_url')
#         })
#     print(videoList)
#     return "HOLA AMIGOES"

# @app.route('/')
# def check():
#     return "FIREBASE with Flask is working"

# if __name__ == '__main__':
#     app.run(port=5000, debug=True)

































# # from collections.abc import MutableMapping
from flask import Flask, json, request, jsonify
import time
import threading
import pyrebase


app= Flask(__name__)

firebase_config={
    'apiKey': "AIzaSyA2Tj-O_iJWC8cDQ86XtXIxvSquy8q_4m4",
    'authDomain': "gsfcu-lms.firebaseapp.com",
    'projectId': "gsfcu-lms",
    'storageBucket': "gsfcu-lms.appspot.com",
    'messagingSenderId': "593020855094",
    'appId': "1:593020855094:web:3fff18afb59baa630b4997",
    'databaseURL': "https://gsfcu-lms-default-rtdb.firebaseio.com/"
}

firebase= pyrebase.initialize_app(firebase_config)
# auth= firebase.auth()
database= firebase.database()
storage= firebase.storage()

#Upload the video file
@app.route('/upload', methods= ['POST'])
def uploadVideos():
    video= request.files['video']
    title= request.form['title']
    category= request.form['category']
    print("all Data received")
    #Define the file path in firebase storage
    file_name= f"{category}/{title}"
    print("defined the name of the file")

    #Upload the video to firebase storage
    storage.child(file_name).put(video)
    print("Uploading completed")

    #Get the URL of the uploaded video
    video_url= storage.child(file_name).get_url(None)
    print("stored in videos collection")

    #Save video metadata to Firestore in the 'videos' collection
    video_data= {
        'title': title, 
        'category': category,
        'video_url': video_url
    }
    print("Created the dictionary or json file")

    #Adding the metadata to the Realtime Database under 'VideoLectures'
    database.child("VideoLectures").push(video_data)

    #Returning the success response
    return jsonify({"message":"Video uploaded and metadata saved successfully", "video_url": video_url})

#Get all videos
@app.route('/getAllVideos', methods=['GET'])
def getAlllectures():
    #Fetching all the info from the VideoLectures node
    videos= database.child("VideoLectures").get()

    videoList=[]
    for video in videos.each():
        video_data= video.val()
        videoList.append({
            'title':video_data.get('title'),
            'category':video_data.get('category'),
            'video_url': video_data.get('video_url'),
        })

    print(videoList)
    return jsonify(videoList)

#Get lectures of a particular subject
@app.route('/getLectures', methods=['GET'])
def getLectures():
    category= request.args.get("category")
    print("Value of category is ", category)

    #Fetching lectures based on the category
    videos= database.child("VideoLectures").order_by_child("category").equal_to(category).get()

    videoList= []
    for video in videos.each():
        video_data= video.val()
        videoList.append({
            'title':video_data.get('title'),
            'category': video_data.get('category'),
            'video_url': video_data.get('video_url'),
        })
    
    print(videoList)
    return jsonify(videoList)

#Verifying the Faculty
@app.route('/verifyFaculty', methods=['POST'])
def verifyProfessor():
    request_data= request.data
    print("Entered")
    request_data= json.loads(request_data.decode('utf-8'))
    print("decoded")
    facultyEmail= request_data['facultyEmail']
    facultyPassword= request_data['facultyPassword']
    # facultyEmail= 'abcd@.com'
    # facultyPassword= 'asdf;j'

    facultyData= database.child("Faculty").order_by_child("email").equal_to(facultyEmail).get().val()

    if facultyData:
        #Verify the password
        for key, faculty in facultyData.items():
            if faculty.get('password') == facultyPassword:
                print("user verified")
                return jsonify(True)
            else :
                print("User password not matched")                        
                return jsonify(False)
    
    print("User not present")
    return jsonify(False)

#Verifying the Student
@app.route('/verifyStudent', methods=['POST'])
def verifyStudent():
    try:
        request_data = request.data
        print("Entered")
        request_data = json.loads(request_data.decode('utf-8'))
        print("decoded")
        studentEmail = request_data['studentEmail']
        studentPassword = request_data['studentPassword']

        studentData = database.child("Student").order_by_child("email").equal_to(studentEmail).get().val()

        if studentData:
            # Verify the password
            for key, student in studentData.items():
                if student.get('password') == studentPassword:
                    print("user verified")
                    return jsonify(True)
                else:
                    print("User password not matched")
                    return jsonify(False)

        print("User not present")
        return jsonify(False)
    
    except Exception as e:
        print(f"An error occurred: {e}")
        return jsonify({"error": "An error occurred while verifying the student. Please try again later."}), 500

    
#Adding the faculty
@app.route('/addFaculty', methods= ['POST'])
def addFaculty():
    email= 'xyz@gmail.com'
    password= '12345'

    metadata={
        'email': email,
        'password': password
    }
    database.child("Faculty").push(metadata)
    
    return 'Successfully Added the faculty credentials'

#Adding the student
@app.route('/addStudent', methods=['POST'])
def addStudent():
    email= 'prajwal@gmail.com'
    password= '123456'

    metadata={
        'email': email,
        'password': password
    }

    database.child("Student").push(metadata)
    return "The student is added successfully"


@app.route('/')
def check():
    return "FIREBASE with flask is working"

if __name__== '__main__' :
    app.run(port= 5000, debug= True)