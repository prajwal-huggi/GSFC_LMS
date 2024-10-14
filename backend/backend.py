from flask import Flask, json, jsonify, request
from deep_translator import GoogleTranslator
from transformers import pipeline

app = Flask(__name__)

@app.route("/summarizeApi",methods=['POST'])
def summarize():
    if request.method== 'POST':
        request_data= request.data
        request_data= json.loads(request_data.decode('utf-8'))

        textData= request_data['name']
        langData= request_data['language']

        #Converting the TextData in english language
        if langData!='English':
            textData= GoogleTranslator(source= 'auto', target='en').translate(textData)
        
        #Summarizing the data with the help of bart-large-cnn
        summarizer= pipeline("summarization", model= "facebook/bart-large-cnn")
        summarized= summarizer(textData, max_length= 150, min_length= 30, do_sample= False)
        textData= summarized[0]['summary_text']

        #Now converting the summarized text in its original language
        if langData=='English':
            targetLang= 'en'
        elif langData== 'Gujarati':
            targetLang= 'gu'
        elif langData== 'Hindi':
            targetLang= 'hi'
        elif langData== 'Kannada':
            targetLang= 'kn'
        else :  
            targetLang= 'en'
        translated_summary= GoogleTranslator(source= 'auto', target=targetLang).translate(textData)

        return jsonify({'summarized_text': translated_summary})

@app.route("/translateApi", methods=['POST'])
def translate():
    if request.method == 'POST':
        request_data = request.data
        request_data = json.loads(request_data.decode('utf-8'))

        textData = request_data['name']
        langData = request_data['language']
        targetLang= 'English'
        if langData=='English':
            targetLang= 'en'
        elif langData== 'Gujarati':
            targetLang= 'gu'

        elif langData== 'Hindi':
            targetLang= 'hi'
        
        elif langData== 'Kannada':
            targetLang= 'kn'
        else :  
            targetLang= 'en'

        try:
            # Using deep-translator instead of googletrans
            output = GoogleTranslator(source='auto', target=targetLang).translate(textData)
            print("After output textData:", textData)
            print(output)
            return jsonify({'translated_text': output})
        except Exception as e:
            print("Translation Error:", str(e))
            return jsonify({'error': str(e)}), 500

@app.route("/")
def search():
    print("WORKING")
    return "HELLO BUDDY"

if __name__ == "__main__":
    app.run(port=6000, debug=True)
# from flask import Flask, json, jsonify, request
# from deep_translator import GoogleTranslator
# from transformers import pipeline
# import whisper
# import subprocess

# app = Flask(__name__)

# @app.route("/transcribeApi", methods=['post'])
# def transcribe():
#     if request.method== 'POST':
#         request_data= request.files
#         request_data= json.loads(request_data.decode('utf-8'))
        
#         # Example usage
#         # input_file = "/content/videoplayback.mp4"  # Replace with your actual input file path in Google Colab
#         input_file= request_data['file']
#         process_input(input_file)
#         # Function to convert video to audio using ffmpeg
#         def video_to_audio(video_path, audio_path="output_audio.mp3"):
#             try:
#                 command = f"ffmpeg -i '{video_path}' -q:a 0 -map a '{audio_path}' -y"
#                 subprocess.run(command, shell=True, check=True)
#                 return audio_path
#             except Exception as e:
#                 print(f"Error converting video to audio: {e}")
#                 return None

#         # Load Whisper model
#         model = whisper.load_model("base")  # Use 'base' or any other model as needed

#         # Function to transcribe audio using Whisper locally
#         def transcribe_audio_local(audio_path):
#             try:
#                 result = model.transcribe(audio_path)
#                 return result['text']
#             except Exception as e:
#                 print(f"Error during transcription: {e}")
#                 return None

#         # Main function to process the input
#         def process_input(input_path):
#             file_extension = input_path.split('.')[-1].lower()

#             if file_extension in ['mp4', 'mkv', 'avi']:  # Handle video input
#                 print("Converting video to audio...")
#                 audio_path = video_to_audio(input_path)
#             else:  # Assume it's an audio input
#                 audio_path = input_path

#             if audio_path:
#                 print("Transcribing audio...")
#                 transcript = transcribe_audio_local(audio_path)  # Directly transcribe without splitting

#                 if transcript:
#                     # Print and save transcribed text to file
#                     print(f"Transcribed Text: {transcript}")
#                     with open("transcription.txt", "w") as f:
#                         f.write(transcript)
#                 else:
#                     print("Transcription failed.")
#             else:
#                 print("Audio conversion failed.")

# @app.route("/summarizeApi",methods=['POST'])
# def summarize():
#     if request.method== 'POST':
#         request_data= request.data
#         request_data= json.loads(request_data.decode('utf-8'))

#         textData= request_data['name']
#         langData= request_data['language']

#         #Converting the TextData in english language
#         if langData!='English':
#             textData= GoogleTranslator(source= 'auto', target='en').translate(textData)
        
#         #Summarizing the data with the help of bart-large-cnn
#         summarizer= pipeline("summarization", model= "facebook/bart-large-cnn")
#         summarized= summarizer(textData, max_length= 150, min_length= 30, do_sample= False)
#         textData= summarized[0]['summary_text']

#         #Now converting the summarized text in its original language
#         if langData=='English':
#             targetLang= 'en'
#         elif langData== 'Gujarati':
#             targetLang= 'gu'
#         elif langData== 'Hindi':
#             targetLang= 'hi'
#         elif langData== 'Kannada':
#             targetLang= 'kn'
#         else :  
#             targetLang= 'en'
#         translated_summary= GoogleTranslator(source= 'auto', target=targetLang).translate(textData)

#         return jsonify({'summarized_text': translated_summary})

# @app.route("/translateApi", methods=['POST'])
# def translate():
#     if request.method == 'POST':
#         request_data = request.data
#         request_data = json.loads(request_data.decode('utf-8'))

#         textData = request_data['name']
#         langData = request_data['language']
#         targetLang= 'English'
#         if langData=='English':
#             targetLang= 'en'
#         elif langData== 'Gujarati':
#             targetLang= 'gu'

#         elif langData== 'Hindi':
#             targetLang= 'hi'
        
#         elif langData== 'Kannada':
#             targetLang= 'kn'
#         else :  
#             targetLang= 'en'

#         try:
#             # Using deep-translator instead of googletrans
#             output = GoogleTranslator(source='auto', target=targetLang).translate(textData)
#             print("After output textData:", textData)
#             print(output)
#             return jsonify({'translated_text': output})
#         except Exception as e:
#             print("Translation Error:", str(e))
#             return jsonify({'error': str(e)}), 500

# @app.route("/")
# def search():
#     print("WORKING")
#     return "HELLO BUDDY"

# if __name__ == "__main__":
#     app.run(port=6000, debug=True)

# from flask import Flask, json, jsonify, request
# from deep_translator import GoogleTranslator
# from transformers import pipeline
# import whisper
# import subprocess
# import os

# app = Flask(__name__)

# # Load Whisper model globally to avoid reloading on each request
# model = whisper.load_model("base")

# # Directory to save uploaded files
# UPLOAD_FOLDER = './uploads'
# if not os.path.exists(UPLOAD_FOLDER):
#     os.makedirs(UPLOAD_FOLDER)

# # Function to convert video to audio using ffmpeg
# def video_to_audio(video_path, audio_path="output_audio.mp3"):
#     try:
#         command = f"ffmpeg -i '{video_path}' -q:a 0 -map a '{audio_path}' -y"
#         subprocess.run(command, shell=True, check=True)
#         return audio_path
#     except Exception as e:
#         print(f"Error converting video to audio: {e}")
#         return None

# # Function to transcribe audio using Whisper locally
# def transcribe_audio_local(audio_path):
#     try:
#         result = model.transcribe(audio_path)
#         return result['text']
#     except Exception as e:
#         print(f"Error during transcription: {e}")
#         return None

# # Main function to process the input
# def process_input(input_path):
#     file_extension = input_path.split('.')[-1].lower()

#     if file_extension in ['mp4', 'mkv', 'avi']:  # Handle video input
#         print("Converting video to audio...")
#         audio_path = video_to_audio(input_path)
#     else:  # Assume it's an audio input
#         audio_path = input_path

#     if audio_path:
#         print("Transcribing audio...")
#         transcript = transcribe_audio_local(audio_path)

#         if transcript:
#             return transcript
#         else:
#             print("Transcription failed.")
#             return None
#     else:
#         print("Audio conversion failed.")
#         return None

# @app.route("/transcribeApi", methods=['POST'])
# def transcribe():
#     if 'file' not in request.files:
#         return jsonify({"error": "No file part in the request"}), 400

#     file = request.files['file']

#     if file.filename == '':
#         return jsonify({"error": "No file selected for uploading"}), 400

#     # Save the file to the uploads folder
#     file_path = os.path.join(UPLOAD_FOLDER, file.filename)
#     file.save(file_path)

#     # Process the saved file
#     transcript = process_input(file_path)

#     if transcript:
#         return jsonify({"transcribed_text": transcript}), 200
#     else:
#         return jsonify({"error": "Transcription failed"}), 500

# @app.route("/summarizeApi", methods=['POST'])
# def summarize():
#     request_data = json.loads(request.data.decode('utf-8'))
#     text_data = request_data['name']
#     lang_data = request_data['language']

#     # Convert text to English if not already in English
#     if lang_data.lower() != 'english':
#         text_data = GoogleTranslator(source='auto', target='en').translate(text_data)

#     # Summarize the text using Hugging Face pipeline
#     summarizer = pipeline("summarization", model="facebook/bart-large-cnn")
#     summarized = summarizer(text_data, max_length=150, min_length=30, do_sample=False)
#     summarized_text = summarized[0]['summary_text']

#     # Translate the summary back to the original language
#     lang_map = {
#         'English': 'en',
#         'Gujarati': 'gu',
#         'Hindi': 'hi',
#         'Kannada': 'kn'
#     }

#     target_lang = lang_map.get(lang_data, 'en')
#     translated_summary = GoogleTranslator(source='auto', target=target_lang).translate(summarized_text)

#     return jsonify({'summarized_text': translated_summary})

# @app.route("/translateApi", methods=['POST'])
# def translate():
#     request_data = json.loads(request.data.decode('utf-8'))
#     text_data = request_data['name']
#     lang_data = request_data['language']

#     lang_map = {
#         'English': 'en',
#         'Gujarati': 'gu',
#         'Hindi': 'hi',
#         'Kannada': 'kn'
#     }

#     target_lang = lang_map.get(lang_data, 'en')

#     try:
#         output = GoogleTranslator(source='auto', target=target_lang).translate(text_data)
#         return jsonify({'translated_text': output})
#     except Exception as e:
#         print("Translation Error:", str(e))
#         return jsonify({'error': str(e)}), 500

# @app.route("/")
# def home():
#     return "HELLO BUDDY"
# if __name__ == "__main__":
#     app.run(port=6000, debug=True)
