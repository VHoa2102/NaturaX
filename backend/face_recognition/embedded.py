from deepface import DeepFace

def get_embedding(image_path):
    try:
        result = DeepFace.represent(
            img_path=image_path,
            model_name="VGG-Face",
            enforce_detection=False  
        )
        return result[0]['embedding']
    except Exception as e:
        #print(f" Không thể trích xuất embedding từ {image_path}: {e}")
        return None
