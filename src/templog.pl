#!/usr/bin/python
import os
import glob
import time
 
# make sure latest raspberry pi version is installed
# this is based on DS18B20 sensor 
# Note: must add dtoverlay=w1-gpio to /boot/config.text of the raspberry pi SD card

# load kernal modules for sensor
os.system('modprobe w1-gpio')
os.system('modprobe w1-therm')

# temperature sensor output file
base_dir = '/sys/bus/w1/devices/'
device_folder = glob.glob(base_dir + '28*')[0]
device_file = device_folder + '/w1_slave'

# read temperature file line
def read_temp_line():
    f = open(device_file, 'r')
    lines = f.readlines()
    f.close()
    return lines

# read temperature 
def read_temp():
    lines = read_temp_line()
    while lines[0].strip()[-3:] != 'YES':
        time.sleep(0.2)
        lines = read_temp_line()
    equals_pos = lines[1].find('t=')
    if equals_pos != -1:
        temp_string = lines[1][equals_pos+2:]
        temp_c = float(temp_string) / 1000.0
        temp_f = temp_c * 9.0 / 5.0 + 32.0
        return temp_c, temp_f

# main test print celsius, fahrenheit 
while True:
    print(read_temp())
    time.sleep(1)
