from yolo_pretrained_coco import detect_coco_objects
from yolo_custom import detect_custom_objects
import math

def center_distance(box1, box2):
    cx1 = (box1[0] + box1[2]) / 2
    cy1 = (box1[1] + box1[3]) / 2
    cx2 = (box2[0] + box2[2]) / 2
    cy2 = (box2[1] + box2[3]) / 2
    return math.sqrt((cx1 - cx2) ** 2 + (cy1 - cy2) ** 2)

def run_full_analysis(image_path):
    objs = detect_coco_objects(image_path) + detect_custom_objects(image_path)
    behaviors = []
    score = 0

    # Tách object theo label
    persons       = [o for o in objs if o["label"] == "person"]
    bikes         = [o for o in objs if o["label"] == "bicycle"]
    saplings      = [o for o in objs if o["label"] == "tree_sapling"]
    trash_bins    = [o for o in objs if o["label"] == "trash_bin"]
    trash_bags    = [o for o in objs if o["label"] == "trash_bag"]
    recycle_bins  = [o for o in objs if o["label"] == "recycle_bin"]

    #  Đi xe đạp: person gần bicycle
    for p in persons:
        for b in bikes:
            if center_distance(p["bbox"], b["bbox"]) < 100:
                behaviors.append("Đi xe đạp (phương tiện xanh)")
                score += 10
                break
        else:
            continue
        break

    #  Trồng cây: person gần tree_sapling
    for p in persons:
        for t in saplings:
            if center_distance(p["bbox"], t["bbox"]) < 100:
                behaviors.append("Trồng cây")
                score += 10
                break
        else:
            continue
        break

    #  Bỏ rác đúng nơi: logic mềm dẻo
    added = False

    # Case 1: person gần trash_bin
    for person in persons:
        for bin in trash_bins:
            if center_distance(person["bbox"], bin["bbox"]) < 100:
                behaviors.append("Bỏ rác đúng nơi")
                score += 10
                added = True
                break
        if added:
            break

    # Case 2: trash_bag gần trash_bin (nếu chưa có)
    if not added:
        for bag in trash_bags:
            for bin in trash_bins:
                if center_distance(bag["bbox"], bin["bbox"]) < 100:
                    behaviors.append("Bỏ rác đúng nơi")
                    score += 10
                    added = True
                    break
            if added:
                break

    # Case 3: Đủ bộ person + trash_bag + trash_bin (nếu vẫn chưa có)
    if not added:
        for person in persons:
            for bag in trash_bags:
                for bin in trash_bins:
                    if (center_distance(person["bbox"], bin["bbox"]) < 100 and
                        center_distance(bag["bbox"], bin["bbox"]) < 100):
                        behaviors.append("Bỏ rác đúng nơi")
                        score += 10
                        added = True
                        break
                if added:
                    break
            if added:
                break

    #  Tái chế
    if recycle_bins:
        behaviors.append("Tái chế")
        score += 10

    # Tập hợp nhãn đã phát hiện
    labels = list(set([o["label"] for o in objs]))

    return {
        "labels": labels,
        "behaviors": behaviors,
        "score": score
    }
