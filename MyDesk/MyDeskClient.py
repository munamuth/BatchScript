import socket
import cv2
import pickle
import struct
import threading

server_ip = input("Enter Server IP Address: ")
client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client_socket.connect((server_ip, 9999))

data = b""
payload_size = struct.calcsize("Q")

# 🔹 Define click handler
def click_event(event, x, y, flags, param):
    if event == cv2.EVENT_LBUTTONDOWN:
        send_click("click_left", x, y)
    elif event == cv2.EVENT_RBUTTONDOWN:
        send_click("click_right", x, y)

def send_click(action, x, y):
    command = f"{action},{x},{y}"
    encoded = command.encode()
    try:
        client_socket.sendall(struct.pack("Q", len(encoded)) + encoded)
    except Exception as e:
        print("[-] Failed to send click:", e)

# 🔹 Main receive loop
mouse_callback_set = False

while True:
    try:
        # Receive header
        while len(data) < payload_size:
            packet = client_socket.recv(4096)
            if not packet:
                raise ConnectionError("Disconnected")
            data += packet

        packed_msg_size = data[:payload_size]
        data = data[payload_size:]
        msg_size = struct.unpack("Q", packed_msg_size)[0]

        # Receive frame
        while len(data) < msg_size:
            data += client_socket.recv(4096)

        frame_data = data[:msg_size]
        data = data[msg_size:]

        buffer = pickle.loads(frame_data)
        frame = cv2.imdecode(buffer, cv2.IMREAD_COLOR)

        # Show frame
        cv2.imshow("MyDesk - Remote View", frame)

        # 🔹 Set mouse callback once (after window appears)
        if not mouse_callback_set:
            cv2.setMouseCallback("MyDesk - Remote View", click_event)
            mouse_callback_set = True

        if cv2.waitKey(1) == ord('q'):
            break

    except Exception as e:
        print("[-] Error:", e)
        break

client_socket.close()
