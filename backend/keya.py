import whisper
import moviepy.editor as mp
import Levenshtein as lev
from pathlib import Path  # Import pathlib

# from flask import Flask, json, jsonify

# app= Flask(__name__)

def extract_audio_from_video(video_file, output_audio_file):
    """Extracts audio from the video file and saves it as an audio file."""
    try:
        video = mp.VideoFileClip(video_file)
        video.audio.write_audiofile(output_audio_file)
    except Exception as e:
        print(f"Error extracting audio from video: {e}")
        raise

def transcribe_audio_with_whisper(audio_file, model_size="base", language=None):
    """Transcribes audio to text using Whisper with multilingual support."""
    try:
        model = whisper.load_model(model_size)  # Load the Whisper model
        options = {"language": language} if language else {}  # Language option
        result = model.transcribe(audio_file, **options)  # Transcribe audio
        return result['text']
    except Exception as e:
        print(f"Error during transcription: {e}")
        raise

def main(input_file, model_size="base", language=None):
    """Main function to handle the transcription process."""
    print("Entered main function...")

    audio_file = "extracted_audio.mp3"  # Temporary file to store extracted audio

    # Step 1: Check if it's a video file and extract audio
    if input_file.endswith(('.mp4', '.avi', '.mkv', '.mov')):
        print("Extracting audio from video file...")
        extract_audio_from_video(input_file, audio_file)
        input_audio_file = audio_file
    else:
        input_audio_file = input_file

    # Step 2: Transcribe the audio to text with Whisper
    print(f"Transcribing audio using Whisper '{model_size}' model with language '{language}'...")
    transcribed_text = transcribe_audio_with_whisper(input_audio_file, model_size, language)

    # Step 3: Display the transcribed text
    print("\nTranscribed Text:")
    print(transcribed_text)

    # Clean up the extracted audio file using pathlib (no os required)
    audio_file_path = Path(audio_file)  # Create Path object for the file
    if audio_file_path.exists():
        audio_file_path.unlink()  # Remove the file
        print("Cleaned up the extracted audio file.")

if __name__ == "__main__":
    # Specify the input file (audio or video)
    input_file = "/Users/prajwal/Downloads/professor.mp4"

    # Specify language code (optional)
    language = "en"

    # Run the main function
    main(input_file, model_size="base", language=language)
