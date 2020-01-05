import os
import time
import timeit

mode=0
mode_host="host"
mode_device="device"
path_role_switch="/sys/class/usb_role/ffe09000.usb-role-switch"
filename="role_switch_perf.csv"

f = open(filename, "w+")

while 1:
        if mode % 2 == 0:
                mode_string = mode_device
        else:
                mode_string = mode_host

        print("Switching to mode " + mode_string + "...")

        t = time.process_time()

        os.system("echo " + mode_string + " > " + path_role_switch + "/role")

        end = timeit.timeit()

        elapsed_time = time.process_time() - t  
        elapsed_time = format(elapsed_time, '.6f')

        print("Done. Elapsed = " + elapsed_time + "s")

        f.write(str(mode) + ";" + mode_string + ";" + str(elapsed_time) + "\n")

        time.sleep(5)

        mode=mode+1

f.close()
