import os
import cv2
from yolo_sum import run_full_analysis

def test_behavior_detection():
    current_dir = os.path.dirname(__file__)
    video_path = os.path.join(current_dir, "test", "video_sample.mp4")

    # Trích frame đầu tiên từ video
    cap = cv2.VideoCapture(video_path)
    ret, frame = cap.read()
    cap.release()

    if not ret:
        print(" Không đọc được video.")
        return

    temp_image_path = os.path.join(current_dir, "test", "temp_frame.jpg")
    cv2.imwrite(temp_image_path, frame)

    # Phân tích frame bằng YOLO
    result = run_full_analysis(temp_image_path)

    print(f" Nhãn phát hiện: {', '.join(result['labels'])}")
    print(" Hành vi phát hiện:")
    for b in result['behaviors']:
        print(f"   {b}")
    print(f" Tổng điểm xanh: {result['score']} điểm")

if __name__ == "__main__":
    test_behavior_detection()
