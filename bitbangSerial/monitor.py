import RPi.GPIO as GPIO
import time

GPIO.setwarnings(False)

PIN_FROM_NES = 17 # Data from NES to RPi
PIN_D0 = 27  # Data from RPi to NES
PIN_D3 = 23  # Clock from RPi to NES
PIN_D4 = 22  # Reset from RPi

GPIO.setmode(GPIO.BCM)

GPIO.setup(PIN_FROM_NES, GPIO.IN)

GPIO.setup(PIN_D0, GPIO.OUT)
GPIO.setup(PIN_D3, GPIO.OUT) 
GPIO.setup(PIN_D4, GPIO.OUT) 

# Set all pins to low
GPIO.output(PIN_D0, 0)
GPIO.output(PIN_D3, 0)
GPIO.output(PIN_D4, 0)

def send_byte(data):
    pos = 0x80
    for i in range(8):
        b = (data & pos) != 0
        print(">>>",b)
        GPIO.output(PIN_D0, b)
        pos >>= 1
        GPIO.output(PIN_D3, 1)
        time.sleep(0.1)
        GPIO.output(PIN_D3, 0)
        time.sleep(0.1)
    GPIO.output(PIN_D0, 0)

def read_byte():
    data = 0    
    for _ in range(8):
        data <<= 1
        if GPIO.input(PIN_FROM_NES):
            data |= 1
        GPIO.output(PIN_D3, 1)
        time.sleep(0.1)
        GPIO.output(PIN_D3, 0)
        time.sleep(0.1)
    return data # 3 + 150 = 153

def cmd_write_byte(address, data):
    send_byte(1)
    time.sleep(0.5)
    send_byte(address&0xFF)
    time.sleep(0.5)
    send_byte((address>>8)&0xFF)
    time.sleep(0.5)
    send_byte(data)
    time.sleep(0.5)

def cmd_read_byte(address):
    send_byte(2)
    time.sleep(0.5)
    send_byte(address&0xFF)
    time.sleep(0.5)
    send_byte((address>>8)&0xFF)
    time.sleep(0.5)
    ret = read_byte()
    time.sleep(0.5)
    return ret