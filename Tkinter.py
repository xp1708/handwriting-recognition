# draw_app.py

import tkinter as tk
from PIL import Image, ImageDraw, ImageOps
import numpy as np

canvas_size = 280
image_size = 28
scale = canvas_size // image_size

image = Image.new("L", (canvas_size, canvas_size), color=255)
draw = ImageDraw.Draw(image)

def draw_line(event):
    x, y = event.x, event.y
    r = 8
    draw.ellipse([x - r, y - r, x + r, y + r], fill=0)
    canvas.create_oval(x - r, y - r, x + r, y + r, fill="black", outline="black")

def clear_canvas():
    global image, draw
    canvas.delete("all")
    image = Image.new("L", (canvas_size, canvas_size), color=255)
    draw = ImageDraw.Draw(image)

def process_and_display():
    resized = image.resize((28, 28), Image.Resampling.LANCZOS)
    resized = ImageOps.invert(resized)
    arr = np.asarray(resized)

    print("\n=== IMAGE DATA 28x28 (uint8) ===")
    for row in arr:
        print(" ".join(f"{int(px):02x}" for px in row))



root = tk.Tk()
root.title("Draw Digit - Export Input 784")


canvas = tk.Canvas(root, width=canvas_size, height=canvas_size, bg='white')
canvas.pack()

canvas.bind("<B1-Motion>", draw_line)

btn_frame = tk.Frame(root)
btn_frame.pack()

btn_clear = tk.Button(btn_frame, text="Xóa", command=clear_canvas)
btn_clear.pack(side=tk.LEFT, padx=10)

btn_process = tk.Button(btn_frame, text="Xuất input[784]", command=process_and_display)
btn_process.pack(side=tk.LEFT, padx=10)

root.mainloop()
