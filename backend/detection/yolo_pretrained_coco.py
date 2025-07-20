# detection/yolo_pretrained_coco.py
import os
from ultralytics import YOLO

BASE_DIR = os.path.dirname(__file__)
MODEL_PATH = os.path.join(BASE_DIR, "yolov8n.pt")  # nếu model ở detection/yolov8n.pt

def detect_coco_objects(image_path):
    model = YOLO(MODEL_PATH)
    results = model.predict(source=image_path, conf=0.4, verbose=False)
    output = []

    for box in results[0].boxes:
        cls_id = int(box.cls[0])
        label = results[0].names[cls_id]
        x1, y1, x2, y2 = map(int, box.xyxy[0])
        output.append({
            "label": label,
            "bbox": (x1, y1, x2, y2)
        })

    return output
