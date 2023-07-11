import serial
import platform

# TODO check OS
ARDUINO_PATH = "/dev/tty.usbserial-130" if platform.system() == "Darwin" else "/dev/ttyUSB0"

print("Opening serial port")
arduino = serial.Serial(port=ARDUINO_PATH, baudrate=115200, timeout=.5)

print("Listening to notes")
with open("CMIINTRO.MID", 'rb') as infile:
    byte = infile.read(1)
    while byte != b"":
        print('written_bytes:', arduino.write(byte))
        byte = infile.read()
