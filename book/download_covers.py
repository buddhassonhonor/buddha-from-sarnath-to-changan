# -*- coding: utf-8 -*-
"""
download_covers.py
Downloads five distinct cover candidate images from Wikimedia Commons 
and saves them to book/images/cover/ with descriptive names.
"""

import os
import hashlib
import urllib.parse
import subprocess
import time

BOOK_DIR = os.path.dirname(os.path.abspath(__file__))
COVER_DIR = os.path.join(BOOK_DIR, "images", "cover")
os.makedirs(COVER_DIR, exist_ok=True)

cover_candidates = [
    {
        "name": "cover_dayan_pagoda.jpg",
        "file": "Giant Wild Goose Pagoda, Xi'an.jpg",
        "description": "西安大雁塔（玄奘法师译经及藏经处，代表书名中的‘长安城’）"
    },
    {
        "name": "cover_vairocana_longmen.jpg",
        "file": "Ancient Buddhist Grottoes at Longmen- Fengxian Temple, Vairocana Buddha.jpg",
        "description": "龙门石窟奉先寺卢舍那大佛（唐代佛教艺术巅峰）"
    },
    {
        "name": "cover_dunhuang_flying_apsara.jpg",
        "file": "Dunhuang mural flying apsarasa.jpg",
        "description": "敦煌莫高窟壁画中的飞天（丝绸之路佛教艺术象征）"
    },
    {
        "name": "cover_sarnath_buddha.jpg",
        "file": "Buddha in Sarnath Museum (Dhammajak Mutra).jpg",
        "description": "初转法轮萨尔纳特佛陀像（笈多王朝艺术杰作，代表书名中的‘鹿野苑’）"
    },
    {
        "name": "cover_pureland.jpg",
        "file": "Chinesischer Maler des 8. Jahrhunderts 001.jpg",
        "description": "唐代《阿弥陀净土图》绢画局部（代表唐代净土宗与长安佛教信仰盛况）"
    }
]

# Rotating list of browser User-Agents
USER_AGENTS = [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/119.0"
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
    local_name = info['name']
    dest_path = os.path.join(COVER_DIR, local_name)
    
    # If already valid, skip
    if is_valid_image(dest_path):
        print(f"  [Skip] Image '{local_name}' already exists and is valid.")
        return True

    filename = info['file']
    widths = [1280, 960, None]
    
    for i, w in enumerate(widths):
        url = get_wikimedia_url(filename, w)
        w_desc = f"{w}px thumbnail" if w else "original size"
        ua = USER_AGENTS[i % len(USER_AGENTS)]
        
        print(f"  [Downloading] '{filename}' as '{local_name}' ({w_desc})...")
        
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
        
        time.sleep(3.0)  # Sleep between width fallbacks
                
    print(f"  [Error] All download options failed for '{filename}'.")
    return False

def main():
    print("=== Start Downloading Cover Candidates ===")
    for candidate in cover_candidates:
        print(f"\nTarget: {candidate['name']}")
        print(f"Description: {candidate['description']}")
        download_image(candidate)
        time.sleep(3.0)  # Sleep between candidates to respect Commons rate limits
    print("\n=== Cover Candidates Download Complete ===")

if __name__ == "__main__":
    main()
