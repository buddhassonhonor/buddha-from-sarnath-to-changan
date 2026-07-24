# -*- coding: utf-8 -*-
"""
download_and_insert_images.py
Downloads and manages all 20 book images + extra Bodhisattva illustrations.
Saves them to book/images/downloaded/ under standardized names, and inserts them 
centered with proper caption formatting into the corresponding chapter .qmd files.
"""

import os
import re
import hashlib
import urllib.parse
import subprocess
import shutil
import time

BOOK_DIR = os.path.dirname(os.path.abspath(__file__))
CHAPS_DIR = os.path.join(BOOK_DIR, "chapters")
IMG_DIR = os.path.join(BOOK_DIR, "images", "downloaded")
AI_IMG_DIR = os.path.join(BOOK_DIR, "images", "ai-generated")

os.makedirs(IMG_DIR, exist_ok=True)

# Main chapter-to-image mapping
image_mapping = {
    "ch01.qmd": {
        "type": "wikimedia",
        "file": "The Great Departure Lahore Museum.jpg",
        "rename": "ch01_departure.jpg",
        "caption": "犍陀罗艺术中的《大出离》浮雕（2-3世纪），巴基斯坦拉合尔博物馆藏",
        "width": "80%"
    },
    "ch02.qmd": {
        "type": "wikimedia",
        "file": "Victory Over Mara - Merjan - Gandhara - Indian Museum - Kolkata 2012-11-16 1934.JPG",
        "rename": "ch02_enlightenment.jpg",
        "caption": "犍陀罗艺术中的《战胜魔罗》（成道）浮雕（2世纪），印度加尔各答印度博物馆藏",
        "width": "85%"
    },
    "ch03.qmd": {
        "type": "wikimedia",
        "file": "Buddha in Sarnath Museum (Dhammajak Mutra).jpg",
        "rename": "ch03_first_sermon.jpg",
        "caption": "萨尔纳特（鹿野苑）出土的初转法轮佛陀像（5世纪，笈多王朝），萨尔纳特考古博物馆藏",
        "width": "80%"
    },
    "ch04.qmd": {
        "type": "wikimedia",
        "file": "Jetavana-Gandhakuti2.jpg",
        "rename": "ch04_jetavana.jpg",
        "caption": "祇园精舍与香室（Gandhakuti）遗迹，舍卫国，印度",
        "width": "80%"
    },
    "ch05.qmd": {
        "type": "wikimedia",
        "file": "Parinirvana stupa of Kushinagar.jpg",
        "rename": "ch05_parinirvana.jpg",
        "caption": "大般涅槃寺与涅槃舍利塔，拘尸那迦，印度",
        "width": "80%"
    },
    "ch06.qmd": {
        "type": "wikimedia",
        "file": "MET DP238220.jpg",
        "rename": "ch06_sutra.jpg",
        "caption": "12世纪《八千颂般若经》贝叶写本，大都会艺术博物馆藏",
        "width": "80%"
    },
    "ch07.qmd": {
        "type": "local-downloaded",
        "file": "ashoka_pillar.jpg",
        "rename": "ch07_ashoka.jpg",
        "caption": "阿育王石柱，毗舍离，印度比哈尔邦（公元前3世纪）",
        "width": "65%"
    },
    "ch08.qmd": {
        "type": "wikimedia",
        "file": "Bamiyan Buddha c1933.jpg",
        "rename": "ch08_bamiyan.jpg",
        "caption": "巴米扬大佛历史照片（1933年），阿富汗（已于2001年被毁）",
        "width": "75%"
    },
    "ch09.qmd": {
        "type": "wikimedia",
        "file": "北宋_彩繪木雕觀音菩薩像（地黃木胎）-Bodhisattva_Avalokiteshvara_(Guanyin)_MET_DP163998.jpg",
        "rename": "ch09_guanyin.jpg",
        "caption": "宋代彩绘木雕观音菩萨坐像，大都会艺术博物馆藏",
        "width": "70%"
    },
    "ch10.qmd": {
        "type": "wikimedia",
        "file": "Chinesischer Maler des 8. Jahrhunderts 001.jpg",
        "rename": "ch10_pureland.jpg",
        "caption": "唐代《阿弥陀净土图》绢画（8世纪），大英博物馆藏",
        "width": "75%"
    },
    "ch11.qmd": {
        "type": "local-downloaded",
        "file": "dunhuang_guanyin.jpg",
        "rename": "ch11_dunhuang.jpg",
        "caption": "敦煌莫高窟壁画·观世音菩萨",
        "width": "70%"
    },
    "ch12.qmd": {
        "type": "wikimedia",
        "file": "Kumarajiva at Kizil Caves, Kuqa.jpg",
        "rename": "ch12_kumarajiva.jpg",
        "caption": "鸠摩罗什铜像，克孜尔石窟前，新疆库车",
        "width": "70%"
    },
    "ch13.qmd": {
        "type": "local-downloaded",
        "file": "xuanzang.jpg",
        "rename": "ch13_xuanzang.jpg",
        "caption": "玄奘法师画像",
        "width": "55%"
    },
    "ch14.qmd": {
        "type": "local-downloaded",
        "file": "jianzhen.jpg",
        "rename": "ch14_jianzhen.jpg",
        "caption": "鉴真和尚漆夹纻像，唐招提寺，日本奈良（8世纪）",
        "width": "55%"
    },
    "ch15.qmd": {
        "type": "wikimedia",
        "file": "Bodhidharma.and.Huike-Sesshu.Toyo.jpg",
        "rename": "ch15_zen.jpg",
        "caption": "雪舟等杨绘《慧可断臂图》（1496年，日本国宝），爱知县齐年寺藏",
        "width": "75%"
    },
    "ch16.qmd": {
        "type": "wikimedia",
        "file": "Huineng Cut Bamboo.jpg",
        "rename": "ch16_huineng.jpg",
        "caption": "梁楷《六祖截竹图》（13世纪），东京国立博物馆藏",
        "width": "60%"
    },
    "ch17.qmd": {
        "type": "wikimedia",
        "file": "Foguang Temple 8.JPG",
        "rename": "ch17_foguang.jpg",
        "caption": "五台山佛光寺东大殿外景（唐代建筑，公元857年）",
        "width": "80%"
    },
    "ch18.qmd": {
        "type": "wikimedia",
        "file": "The wheel of life, Trongsa dzong.jpg",
        "rename": "ch18_wheel.jpg",
        "caption": "Trongsa dzong壁画中的六道轮回图（Bhavachakra），不丹",
        "width": "75%"
    },
    "ch19.qmd": {
        "type": "wikimedia",
        "file": "Taixu.jpg",
        "rename": "ch19_taixu.jpg",
        "caption": "太虚大师（1890—1947）法相",
        "width": "60%"
    },
    "ch20.qmd": {
        "type": "wikimedia",
        "file": "RyoanJi-Dry garden.jpg",
        "rename": "ch20_ryoanji.jpg",
        "caption": "龙安寺枯山水石庭，日本京都",
        "width": "80%"
    }
}

# Extra images to insert inside chapter subsections (e.g. Chapter 9 Bodhisattva subsections)
extra_images = {
    "ch09_manjusri.jpg": {
        "file": "Yulin Cave 3 w wall Manjusri (Western Xia).jpg",
        "rename": "ch09_manjusri.jpg"
    },
    "ch09_samantabhadra.jpg": {
        "file": "Yulin Cave 3 w wall Samantabhadra (Western Xia).jpg",
        "rename": "ch09_samantabhadra.jpg"
    },
    "ch09_guanyin_watermoon.png": {
        "file": "水月觀音圖.png",
        "rename": "ch09_guanyin_watermoon.png"
    },
    "ch09_ksitigarbha.jpg": {
        "file": "Kṣitigarbha as Lord of the Six Ways (Stein Painting 19).jpg",
        "rename": "ch09_ksitigarbha.jpg"
    },
    "ch09_maitreya.jpg": {
        "file": "Sitting Maitreya-AO 2910-IMG 8485-gradient.jpg",
        "rename": "ch09_maitreya.jpg"
    }
}


# Original downloaded files to preserve
original_files = {"ashoka_pillar.jpg", "dunhuang_guanyin.jpg", "jianzhen.jpg", "xuanzang.jpg"}

# Rotating list of browser User-Agents
USER_AGENTS = [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/119.0",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
]

def get_wikimedia_url(filename, thumbnail_width=1280):
    norm_name = filename.replace(' ', '_')
    m = hashlib.md5()
    m.update(norm_name.encode('utf-8'))
    h = m.hexdigest()
    encoded_name = urllib.parse.quote(norm_name)
    if thumbnail_width:
        return f"https://upload.wikimedia.org/wikipedia/commons/thumb/{h[0]}/{h[0:2]}/{encoded_name}/{thumbnail_width}px-{encoded_name}"
    else:
        return f"https://upload.wikimedia.org/wikipedia/commons/{h[0]}/{h[0:2]}/{encoded_name}"

def is_valid_image(filepath):
    if not os.path.exists(filepath):
        return False
    if os.path.getsize(filepath) < 1024:
        return False
    try:
        with open(filepath, 'rb') as f:
            start_bytes = f.read(100)
        if b"<!DOCTYPE" in start_bytes or b"<html" in start_bytes or b"Wikimedia Error" in start_bytes:
            return False
    except Exception:
        return False
    return True

def download_image(info):
    local_name = info['rename']
    dest_path = os.path.join(IMG_DIR, local_name)
    
    # If already valid, skip
    if is_valid_image(dest_path):
        print(f"  [Skip] Image '{local_name}' already exists and is valid.")
        return True

    # 1. Handle local copies first
    if info.get('type') == 'ai-generated':
        src_path = os.path.join(AI_IMG_DIR, info['file'])
        if os.path.exists(src_path):
            shutil.copy2(src_path, dest_path)
            print(f"  [Copy] Copied AI-generated {info['file']} to {local_name}")
            return True
        else:
            print(f"  [Error] Source AI image not found: {src_path}")
            return False

    elif info.get('type') == 'local-downloaded':
        src_path = os.path.join(IMG_DIR, info['file'])
        if os.path.exists(src_path):
            shutil.copy2(src_path, dest_path)
            print(f"  [Copy] Copied local downloaded {info['file']} to {local_name}")
            return True
        else:
            print(f"  [Error] Source downloaded image not found: {src_path}")
            return False

    # 2. Handle Wikimedia downloads
    filename = info['file']
    widths = [1280, 960, None]
    
    for i, w in enumerate(widths):
        url = get_wikimedia_url(filename, w)
        w_desc = f"{w}px thumbnail" if w else "original size"
        ua = USER_AGENTS[i % len(USER_AGENTS)]
        
        print(f"  [Downloading] '{filename}' as '{local_name}' ({w_desc}) from {url}...")
        
        temp_dest = dest_path + ".tmp"
        if os.path.exists(temp_dest):
            os.remove(temp_dest)
            
        cmd = [
            "curl.exe",
            "-s",
            "-L",
            "-o", temp_dest,
            "-H", f"User-Agent: {ua}",
            url
        ]
        
        try:
            subprocess.run(cmd, capture_output=True, text=True, check=True)
            if is_valid_image(temp_dest):
                if os.path.exists(dest_path):
                    os.remove(dest_path)
                os.rename(temp_dest, dest_path)
                print(f"  [Success] Saved to {dest_path} ({os.path.getsize(dest_path)} bytes)")
                return True
            else:
                if os.path.exists(temp_dest):
                    os.remove(temp_dest)
                print(f"  [Failed] Download failed or returned HTML error page for {w_desc}.")
        except Exception as e:
            print(f"  [Error] Exception during download of {w_desc}: {e}")
            if os.path.exists(temp_dest):
                os.remove(temp_dest)
        
        time.sleep(2.0)  # Moderate sleep between download attempts
                
    print(f"  [Error] All download options failed for '{filename}'.")
    return False

def insert_images_ch09(content):
    content = content.replace('\r\n', '\n')
    
    # 1. Manjusri
    if "../images/downloaded/ch09_manjusri.jpg" not in content:
        content = re.sub(
            r'(### 1\. 文殊菩萨：智慧不是聪明，而是不被成见遮蔽\n)',
            r'\1\n![西夏壁画《文殊菩萨赴会图》（12世纪），瓜州榆林窟第3窟](../images/downloaded/ch09_manjusri.jpg){width=80% fig-align="center"}\n',
            content
        )
        
    # 2. Samantabhadra
    if "../images/downloaded/ch09_samantabhadra.jpg" not in content:
        content = re.sub(
            r'(### 2\. 普贤菩萨：再宏大的愿，也要落实为行动\n)',
            r'\1\n![西夏壁画《普贤菩萨赴会图》（12世纪），瓜州榆林窟第3窟](../images/downloaded/ch09_samantabhadra.jpg){width=80% fig-align="center"}\n',
            content
        )
        
    # 3. Guanyin
    if "../images/downloaded/ch09_guanyin_watermoon.png" not in content:
        content = re.sub(
            r'(### 3\. 观音菩萨：听见世间的声音\n)',
            r'\1\n![西夏壁画《水月观音图》（12世纪），瓜州榆林窟第2窟](../images/downloaded/ch09_guanyin_watermoon.png){width=70% fig-align="center"}\n',
            content
        )

        
    # 4. Ksitigarbha
    if "../images/downloaded/ch09_ksitigarbha.jpg" not in content:
        content = re.sub(
            r'(### 4\. 地藏菩萨：最幽暗的地方，也不轻易舍弃\n)',
            r'\1\n![唐代绢画《地藏菩萨十王图》（10世纪），敦煌莫高窟出土，大英博物馆藏](../images/downloaded/ch09_ksitigarbha.jpg){width=65% fig-align="center"}\n',
            content
        )
        
    # 5. Maitreya
    if "../images/downloaded/ch09_maitreya.jpg" not in content:
        content = re.sub(
            r'(### 5\. 弥勒菩萨：未来仍有成佛与改善的可能\n)',
            r'\1\n![犍陀罗艺术中的弥勒菩萨坐像（2-3世纪），吉美国立亚洲艺术博物馆藏](../images/downloaded/ch09_maitreya.jpg){width=75% fig-align="center"}\n',
            content
        )
        
    return content

def insert_image_link(qmd_name, info):
    qmd_path = os.path.join(CHAPS_DIR, qmd_name)
    if not os.path.exists(qmd_path):
        print(f"  [Warning] Chapter file '{qmd_name}' does not exist.")
        return False
        
    with open(qmd_path, 'r', encoding='utf-8') as f:
        content = f.read()
        
    target_link = f"../images/downloaded/{info['rename']}"
    
    # We enforce centered block image formatting: blank lines before and after, fig-align="center"
    img_md = f"\n\n![{info['caption']}]({target_link}){{width={info['width']} fig-align=\"center\"}}\n\n"
    
    # Look for any existing image reference (matches downloaded or ai-generated links)
    img_pattern = r'\n*!\[.*?\]\(\.\./images/(?:downloaded|ai-generated)/.*?\)(?:\{.*?\}|)\n*'
    
    if re.search(img_pattern, content):
        new_content = re.sub(img_pattern, img_md, content, count=1)
        print(f"  [Updated] Replaced/reformatted image link in {qmd_name}")
    else:
        new_content = content.replace('---\n\n', '---\n\n' + img_md, 1)
        print(f"  [Updated] Inserted image in {qmd_name}")
        
    # Standardize spacing: ensure no triple newlines
    new_content = re.sub(r'\n{3,}', '\n\n', new_content)
    
    # Custom post-processing for Chapter 9 to insert subsection images
    if qmd_name == "ch09.qmd":
        new_content = insert_images_ch09(new_content)
        
    with open(qmd_path, 'w', encoding='utf-8', newline='\n') as f:
        f.write(new_content)
    return True

def cleanup_old_images():
    print("\nCleaning up un-renamed and unused files in images/downloaded...")
    allowed_files = original_files.copy()
    for info in image_mapping.values():
        allowed_files.add(info['rename'])
    for info in extra_images.values():
        allowed_files.add(info['rename'])
        
    deleted_count = 0
    for entry in os.scandir(IMG_DIR):
        if entry.is_file() and entry.name not in allowed_files:
            try:
                os.remove(entry.path)
                print(f"  [Deleted] Removed unused file: {entry.name}")
                deleted_count += 1
            except Exception as e:
                print(f"  [Error] Failed to delete {entry.name}: {e}")
                
    print(f"Cleanup complete. Deleted {deleted_count} files.")

def main():
    print("=== Start Managing Images & Updating Chapters ===")
    success_count = 0
    total = len(image_mapping)
    
    # 1. Download and process main images
    for qmd_name, info in image_mapping.items():
        print(f"\nProcessing {qmd_name}...")
        download_ok = download_image(info)
        if download_ok:
            insert_ok = insert_image_link(qmd_name, info)
            if insert_ok:
                success_count += 1
                
    # 2. Download extra images
    print("\n=== Sourcing and Downloading Extra Subsection Images ===")
    for name, info in extra_images.items():
        print(f"\nProcessing extra image {name}...")
        download_info = {
            "file": info["file"],
            "rename": info["rename"]
        }
        download_image(download_info)
        
    # Re-apply inserts to Chapter 9 to make sure extra images are correctly linked
    insert_image_link("ch09.qmd", image_mapping["ch09.qmd"])
        
    # 3. Clean up old files
    cleanup_old_images()
                
    print(f"\n=== Finished! Successfully processed {success_count}/{total} chapters ===")

if __name__ == "__main__":
    main()
