# recognize.py
import os
import numpy as np
from embedded import get_embedding
from scipy.spatial.distance import cosine

def recognize_face(test_image_path, known_faces_dir="data_face", threshold=0.6):
    test_embedding = get_embedding(test_image_path)
    if test_embedding is None:
        return "Unknown"
    min_distance = float('inf')
    recognized_name = "Unknown"

    for fname in os.listdir(known_faces_dir):
        person_name = os.path.splitext(fname)[0]
        known_path = os.path.join(known_faces_dir, fname)

        known_embedding = get_embedding(known_path)
        if known_embedding is None:
            continue

        distance = cosine(test_embedding, known_embedding)

        if distance < threshold and distance < min_distance:
            min_distance = distance
            recognized_name = person_name

    return recognized_name
