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