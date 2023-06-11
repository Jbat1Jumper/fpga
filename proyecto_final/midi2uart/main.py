import mido
import serial
import time

#print("Opening serial port")
#arduino = serial.Serial(port='/dev/ttyUSB0', baudrate=9600, timeout=.5)

print("Listing inputs")
input_names = set(mido.get_input_names())
for name in input_names:
    print("-", name)

selected_input = next(filter(lambda n: "nano" in n, input_names))
print("Selected input:", selected_input)

print("Listening to notes")
with mido.open_input(selected_input) as inport:
    for msg in inport:
        msg_bytes_h = ','.join('{:02x}'.format(x) for x in msg.bytes()).upper()
        print(msg, 'bytes:', msg_bytes_h)





# num = 0
# 
# while True:
#     num += 1
#     print("Current num", num)
#     arduino.write(bytes(str(num), 'utf-8'))
#     time.sleep(0.05)
# 
