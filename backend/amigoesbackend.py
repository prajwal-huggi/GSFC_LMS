import os
from flask import Flask, request, render_template, redirect, url_for
import whisper
import moviepy.editor as mp
import Levenshtein as lev
from werkzeug.utils import secure_filename
from transformers import pipeline
import nltk

nltk.download('punkt')

app = Flask(__name__)

# Configure upload folder
UPLOAD_FOLDER = 'static/uploads/'
ALLOWED_EXTENSIONS = {'mp4', 'avi', 'mkv', 'mov', 'mp3', 'wav'}

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Helper function to check allowed file extensions
def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

# Function to extract audio from video
def extract_audio_from_video(video_file, output_audio_file):
    """Extracts audio from video and saves as an audio file."""
    video = mp.VideoFileClip(video_file)
    video.audio.write_audiofile(output_audio_file)

# Transcribe audio using Whisper
def transcribe_audio_with_whisper(audio_file, model_size="base", language=None):
    """Transcribes audio to text using Whisper with multilingual support."""
    model = whisper.load_model(model_size)
    options = {"language": language} if language else {}
    result = model.transcribe(audio_file, **options)
    return result['text']

# Summarize text using transformers' pipeline
def summarize_text(transcribed_text):
    """Summarizes the lecture transcription."""
    summarizer = pipeline("summarization", model="facebook/bart-large-cnn")
    return summarizer(transcribed_text, max_length=150, min_length=30, do_sample=False)[0]['summary_text']

@app.route('/', methods=['GET', 'POST'])
def dashboard():
    if request.method == 'POST':
        # Handle file uploads and options
        task = request.form.get('task')  # General transcription or Lecture summarization
        file = request.files['file']
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            file_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
            file.save(file_path)

            # General transcription or lecture processing
            if task == 'general':
                audio_file = file_path
                if filename.endswith(('.mp4', '.avi', '.mkv', '.mov')):
                    audio_file = os.path.join(app.config['UPLOAD_FOLDER'], "extracted_audio.mp3")
                    extract_audio_from_video(file_path, audio_file)

                transcribed_text = transcribe_audio_with_whisper(audio_file, model_size='base', language='en')

                return render_template('result.html', transcribed_text=transcribed_text, summarization=None)
            
            elif task == 'lecture':
                audio_file = file_path
                if filename.endswith(('.mp4', '.avi', '.mkv', '.mov')):
                    audio_file = os.path.join(app.config['UPLOAD_FOLDER'], "extracted_audio.mp3")
                    extract_audio_from_video(file_path, audio_file)

                transcribed_text = transcribe_audio_with_whisper(audio_file, model_size='medium', language='en')
                summarization = summarize_text(transcribed_text)

                return render_template('result.html', transcribed_text=transcribed_text, summarization=summarization)

    return render_template('dashboard.html')

if __name__ == '_main_':
    app.run(debug=True)