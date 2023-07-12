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
for msg in MidiFile('simpsons-3.mid'):
    time.sleep(msg.time)
    if not msg.is_meta:
        if msg.type in ["note_on", "note_off"]:
            # Down two octaves
            msg.note -= 24
        msg_bytes_h = ','.join('{:02x}'.format(x) for x in msg.bytes()).upper()
        print(msg, 'bytes:', msg_bytes_h)
        arduino.write(msg.bytes())
