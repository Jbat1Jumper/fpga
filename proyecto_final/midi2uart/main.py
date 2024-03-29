import mido
import serial
import platform

if platform.system() == "Darwin":
    mido.set_backend("mido.backends.pygame")

# TODO check OS
ARDUINO_PATH = "/dev/tty.usbserial-130" if platform.system() == "Darwin" else "/dev/ttyUSB0"

print("Opening serial port")
arduino = serial.Serial(port=ARDUINO_PATH, baudrate=115200, timeout=.5)

print("Listing inputs")
input_names = set(mido.get_input_names())
for name in input_names:
    print("-", name)

selected_input = next(filter(lambda n: "nano" in n, input_names))
print("Selected input:", selected_input)

values = [0, 1, 2, 3]

print("Listening to notes")
with mido.open_input(selected_input) as inport:
    for msg in inport:
        msg_bytes_h = ','.join('{:02x}'.format(x) for x in msg.bytes()).upper()
        print(msg, 'bytes:', msg_bytes_h)
        arduino.write(msg.bytes())

# num = 0
# 
# while True:
#     num += 1
#     print("Current num", num)
#     arduino.write(bytes(str(num), 'utf-8'))
#     time.sleep(0.05)
# 
