# detection/test.py
import os
from yolo_sum import run_full_analysis

def test_behavior_detection():
    current_dir = os.path.dirname(__file__)
    image_path = os.path.join(current_dir, "test", "test4.jpg")

    result = run_full_analysis(image_path)

    print(f" Nhãn phát hiện: {', '.join(result['labels'])}")
    print(" Hành vi phát hiện:")
    for b in result['behaviors']:
        print(f"   {b}")
    print(f" Tổng điểm xanh: {result['score']} điểm")

if __name__ == "__main__":
    test_behavior_detection()

