import os
import shutil
import random

base_dir = os.path.dirname(__file__)
img_src = os.path.join(base_dir, "img_all")
lbl_src = os.path.join(base_dir, "label_all")

# Tạo thư mục output
for phase in ["train", "val"]:
    os.makedirs(os.path.join(base_dir, f"images/{phase}"), exist_ok=True)
    os.makedirs(os.path.join(base_dir, f"labels/{phase}"), exist_ok=True)

images = [f for f in os.listdir(img_src) if f.endswith(('.jpg', '.png'))]
random.shuffle(images)

split = int(0.8 * len(images))
train_set = images[:split]
val_set = images[split:]

def copy_phase(file_list, phase):
    for f in file_list:
        shutil.copy2(os.path.join(img_src, f), os.path.join(base_dir, f"images/{phase}/{f}"))
        txt = f.rsplit(".", 1)[0] + ".txt"
        shutil.copy2(os.path.join(lbl_src, txt), os.path.join(base_dir, f"labels/{phase}/{txt}"))

copy_phase(train_set, "train")
copy_phase(val_set, "val")

print(f"✅ Đã chia: {len(train_set)} train, {len(val_set)} val")
