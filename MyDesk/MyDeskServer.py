import socket
import cv2
import pickle
import struct
import pyautogui
import numpy as np
import threading

def handle_client(client_socket, addr):
    print(f"[+] Client connected from {addr}")

    def video_stream():
        while True:
            try:
                screen = pyautogui.screenshot(region=(0, 0, 1024, 768))
                frame = cv2.cvtColor(np.array(screen), cv2.COLOR_RGB2BGR)
                result, buffer = cv2.imencode('.jpg', frame, [int(cv2.IMWRITE_JPEG_QUALITY), 50])
                if not result:
                    break
                data = pickle.dumps(buffer)
                message = struct.pack("Q", len(data)) + data
                client_socket.sendall(message)
            except Exception as e:
                print(f"[-] Video stream error: {e}")
                break

    def receive_control():
        while True:
            try:
                cmd_len = struct.unpack("Q", client_socket.recv(8))[0]
                command = client_socket.recv(cmd_len).decode()
                parts = command.split(',')
                action = parts[0]
                x, y = int(parts[1]), int(parts[2])

                pyautogui.moveTo(x, y)
                if action == "click_left":
                    pyautogui.click()
                elif action == "click_right":
                    pyautogui.click(button='right')

            except Exception as e:
                print(f"[-] Control stream error: {e}")
                break

    threading.Thread(target=video_stream, daemon=True).start()
    threading.Thread(target=receive_control, daemon=True).start()

while True:
    try:
        server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        server_socket.bind(("0.0.0.0", 9999))
        server_socket.listen(5)
        print("[*] MyDesk Server started, waiting for clients...")

        while True:
            client, addr = server_socket.accept()
            threading.Thread(target=handle_client, args=(client, addr), daemon=True).start()

    except KeyboardInterrupt:
        print("\n[!] Server shutting down.")
        break
    except Exception as e:
        print(f"[-] Server error: {e}")
        break

server_socket.close()
