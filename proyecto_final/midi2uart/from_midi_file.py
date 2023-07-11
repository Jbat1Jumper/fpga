import mido
import serial
import platform
from mido import MidiFile
import time

if platform.system() == "Darwin":
    mido.set_backend("mido.backends.pygame")

# TODO check OS
ARDUINO_PATH = "/dev/tty.usbserial-130" if platform.system() == "Darwin" else "/dev/ttyUSB0"

print("Opening serial port")
arduino = serial.Serial(port=ARDUINO_PATH, baudrate=115200, timeout=.5)

values = [0, 1, 2, 3]

print("Playing Song")
for msg in MidiFile('CMIIntro.MID'):
    time.sleep(msg.time)
    if not msg.is_meta:
        msg_bytes_h = ','.join('{:02x}'.format(x) for x in msg.bytes()).upper()
        biites = (msg.note % 4).to_bytes(length=1, byteorder="little")
        print(msg, 'bytes:', msg_bytes_h, 'sending:', biites)
        print('written_bytes:', arduino.write(biites))
