import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'  # 0 = all log, 1 = filter INFO, 2 = +WARNING, 3 = only ERROR

from recognise import recognize_face

if __name__ == "__main__":
    path = "test_face/test2.jpg"
    name = recognize_face(path)
    print(f"Nhận diện: {name}")
