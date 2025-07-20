import exifread
from datetime import datetime

def extract_gps_with_timestamp(image_path):
    with open(image_path, 'rb') as f:
        tags = exifread.process_file(f)

    if 'GPS GPSLatitude' not in tags or 'GPS GPSLongitude' not in tags:
        print(" No GPS metadata found")
        return None, None, None, None

    def to_degrees(value):
        d, m, s = [float(x.num) / float(x.den) for x in value.values]
        return d + m / 60.0 + s / 3600.0

    # Lấy tọa độ
    lat = to_degrees(tags['GPS GPSLatitude'])
    if tags.get('GPS GPSLatitudeRef').values != 'N':
        lat = -lat

    lon = to_degrees(tags['GPS GPSLongitude'])
    if tags.get('GPS GPSLongitudeRef').values != 'E':
        lon = -lon

    # Lấy GPS timestamp nếu có
    timestamp_str = None
    timestamp_epoch = None

    if 'GPS GPSDateStamp' in tags and 'GPS GPSTimeStamp' in tags:
        date = tags['GPS GPSDateStamp'].values
        h, m, s = [float(x.num) / float(x.den) for x in tags['GPS GPSTimeStamp'].values]
        timestamp_str = f"{date} {int(h):02}:{int(m):02}:{int(s):02}"
        # Convert sang epoch timestamp
        try:
            dt_obj = datetime.strptime(timestamp_str, "%Y:%m:%d %H:%M:%S")
            timestamp_epoch = int(dt_obj.timestamp())
        except Exception as e:
            print(" Lỗi chuyển đổi timestamp:", e)

    elif 'EXIF DateTimeOriginal' in tags:
        timestamp_str = tags['EXIF DateTimeOriginal'].values
        try:
            dt_obj = datetime.strptime(timestamp_str, "%Y:%m:%d %H:%M:%S")
            timestamp_epoch = int(dt_obj.timestamp())
        except Exception as e:
            print(" Lỗi chuyển đổi timestamp:", e)

    print(" Latitude:", lat)
    print(" Longitude:", lon)
    print(" Time (String):", timestamp_str)
    print(" Time (Epoch):", timestamp_epoch)
    print(f" Google Maps: https://www.google.com/maps?q={lat},{lon}")

    return lat, lon, timestamp_str, timestamp_epoch



#test thử code
img_path = r"d:\Hoc\NaturaX\Python_BE\gps_tracking\data_track\track2.jpg"
extract_gps_with_timestamp(img_path)
