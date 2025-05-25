import tkinter as tk
from PIL import Image, ImageDraw, ImageOps
import numpy as np
import serial

# =========================
# UART Config
# =========================
UART_PORT = "COM5"      # Thay bằng cổng COM thật sự
UART_BAUD = 115200

try:
    ser = serial.Serial(UART_PORT, UART_BAUD)
    print(f"UART opened at {UART_PORT} ({UART_BAUD} baud)")
except Exception as e:
    print(f"Failed to open UART: {e}")
    ser = None

# =========================
# Canvas Config
# =========================
canvas_size = 280
image_size = 28
scale = canvas_size // image_size

image = Image.new("L", (canvas_size, canvas_size), color=255)
draw = ImageDraw.Draw(image)

# =========================
# Drawing Functions
# =========================
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

def export_and_send_uart():
    if ser is None:
        print("UART not available.")
        return

    resized = image.resize((28, 28), Image.Resampling.LANCZOS)
    resized = ImageOps.invert(resized)
    arr = np.asarray(resized, dtype=np.uint8)

    print("\n=== IMAGE DATA 28x28 (HEX) ===")
    for row in arr:
        print(" ".join(f"{int(px):02X}" for px in row))

    # Send over UART
    flattened = arr.flatten()
    ser.write(flattened.tobytes())
    print("Sent 784 bytes over UART.")

    # Save to file (optional)
    with open("img0.hex", "w") as f:
        for val in flattened:
            f.write(f"{val:02X}\n")

# =========================
# GUI Setup
# =========================
root = tk.Tk()
root.title("Digit Drawer - UART Sender")

canvas = tk.Canvas(root, width=canvas_size, height=canvas_size, bg='white')
canvas.pack()
canvas.bind("<B1-Motion>", draw_line)

btn_frame = tk.Frame(root)
btn_frame.pack()

tk.Button(btn_frame, text="Clear", command=clear_canvas).pack(side=tk.LEFT, padx=10)
tk.Button(btn_frame, text="Send UART", command=export_and_send_uart).pack(side=tk.LEFT, padx=10)

root.mainloop()
