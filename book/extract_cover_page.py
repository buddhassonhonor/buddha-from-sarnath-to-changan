# -*- coding: utf-8 -*-
"""
extract_cover_page.py
"""

import fitz
import os

pdf_path = r"d:\宗教大观\Budda\_output\从鹿野苑到长安城.pdf"
output_dir = r"C:\Users\45684\.gemini\antigravity-ide\brain\b9f3f386-f35c-4d16-827d-ce5d6aa3d767"
output_path = os.path.join(output_dir, "cover_preview.png")

def main():
    if not os.path.exists(pdf_path):
        print(f"Error: PDF not found at {pdf_path}")
        return
        
    doc = fitz.open(pdf_path)
    page = doc.load_page(0)  # load the first page (cover page)
    
    # Render page to a pixmap at 150 DPI for high quality
    zoom = 150 / 72
    matrix = fitz.Matrix(zoom, zoom)
    pix = page.get_pixmap(matrix=matrix)
    
    os.makedirs(output_dir, exist_ok=True)
    pix.save(output_path)
    print(f"Successfully saved cover preview to {output_path} ({os.path.getsize(output_path)} bytes)")

if __name__ == "__main__":
    main()
