import sys
import time
import json
from epics import caget, caput, pv
import numpy as np
import statistics 
from np_encoder import NpEncoder

S7NODAVE = "s7nodave"
OPCUA = "opcua"
S7PLC="s7plc"

DEFAULT_READ_NUMBER = 1000


MODULES = [S7NODAVE, OPCUA, S7PLC]

def get_pv_read(module, device_number):
    if device_number == "0":
        return f"{module}:s7:singleBitFromPlc:plccom"
    elif device_number == "1":
        return f"{module}:s7:singleBitFromPlc:plcproc1"
    elif device_number == "2":
        return f"{module}:s7:singleBitFromPlc:plcproc2"
    else:
        return f"{module}:bo{device_number}:notCritical:singlebit:received"

    
def get_pv_write(module, device_number):
    print (device_number)
    if device_number == "0":
        return f"{module}:s7:singleBitToPlc:plccom"
    elif device_number == "1":
        return f"{module}:s7:singleBitToPlc:plcproc1"
    elif device_number == "2":
        return f"{module}:s7:singleBitToPlc:plcproc2"
    else:
        return f"{module}:bo{device_number}:notCritical:singlebit"
    

def compute_and_save_stats(time_diffs, module, device_number, number_of_read, file_num,
                             print_result_dict=True, save_to_file=True, from_docker=False,
                             min_sampling_interval=None, min_publishing_interval=None):
    print(time_diffs)

    mean = np.mean(time_diffs)
    median = np.median(time_diffs)
    variance_val = np.var(time_diffs)
    std_val = np.std(time_diffs)
    min_val = np.amin(time_diffs)
    max_val = np.amax(time_diffs)
    coefficient_of_variation = std_val / mean

    results = {}
    results['data'] = time_diffs
    results['mean'] = mean
    results['median'] = median
    results['variance_val'] = variance_val
    results['std_val'] = std_val
    results['min_val'] = min_val
    results['max_val'] = max_val
    results['cv'] = coefficient_of_variation

    if module == OPCUA:
        results['min_sampling'] = min_sampling_interval
        results['min_publishing'] = min_publishing_interval


    print(f"Mean                     {mean}")
    print(f"Median                   {median}")
    print(f"Variance                 {variance_val}")
    print(f"Standard deviation       {std_val}")
    print(f"Minimum                  {min_val}")
    print(f"Maximum                  {max_val}")

    if print_result_dict:
        print("RESULTS")
        print(results)

    if module == OPCUA:
        filename=f"./results/single_device/singleBit/{module}_{device_number.replace(':', '_')}_{number_of_read}_{min_sampling_interval}_{min_publishing_interval}"
    else:
        filename=f"./results/single_device/singleBit/{module}_{device_number.replace(':', '_')}_{number_of_read}"
 
    if from_docker:
        filename += f"_docker_{file_num}.json"
    else:
        filename += f"_{file_num}.json"

    if save_to_file:
        with open(filename, 'w') as f: 
            json.dump(results, f, indent=4, cls=NpEncoder)


def run(module, device_number, number_of_read, 
        print_result_dict, save_to_file, from_docker, file_num, min_sampling_interval=None, min_publishing_interval=None):
    times_array = []

    pv_name_read =  get_pv_read(module, device_number)
    pv_name_write =  get_pv_write(module, device_number)

    val = caget(pv_name_read)
    caput(pv_name_write, 0)

    while len(times_array) < number_of_read:
        l = len(times_array)
        if l % 20 == 0:
            print(f"Run {l}")
        for i in range(0,2):
            start = time.time()
            caput(pv_name_write, i)
            while val != i:
                val = caget(pv_name_read)
            stop = time.time()
            time_diff = (stop - start) * 1000
            time_diff = int(time_diff)
            # if time_diff < 1500:
            print(f"PV: {pv_name_read}, value: {val}, time: {time_diff}")
            times_array.append(time_diff)
            time.sleep(0.03)
        
    compute_and_save_stats(times_array, module, device_number, number_of_read, file_num,
                            print_result_dict, save_to_file, from_docker,
                            min_sampling_interval, min_publishing_interval)

if __name__ == "__main__":
    if len(sys.argv) < 6:
        print("You have to pass 6 arguments")
        print("Example: python3 measure_time_singlebit.py <module> <device_number> <number_of_read> <save> <source>")
        print("<module> = s7plc / s7nodave / opcua")
        print("<device_number> = [0,3]")
        print("<number_of_read> = default 1000")
        print("<save> = save/no")
        print("<source> = docker/no")
        print("<source> = docker/no")
        print("<file_num> = 1")
        print("<minimum_sampling> = 100")
        print("<minimum_publishing> = 200")
        sys.exit()

    module = sys.argv[1]
    device_number = sys.argv[2]
    number_of_read = sys.argv[3]
    save_to_file = sys.argv[4]
    source = sys.argv[5]
    file_num = sys.argv[6]

    try:
        number_of_read = int(sys.argv[3])
    except: 
        number_of_read = DEFAULT_READ_NUMBER

    if module not in MODULES:
        print(f"Module must be in {MODULES}")
        sys.exit()
    if int(device_number) not in range(0, 4):
        print(f"device_number must be in [0,3]")
        sys.exit()
    if save_to_file.strip().lower() == "save":
        save_to_file = True
    else:
        save_to_file = False
    
    print(f"SOURCE IS: {source}")
    if source.strip().lower() == "docker":
        from_docker = True
    else:
        from_docker = False


    if module == OPCUA:
        try:
            min_sampling_interval = int(sys.argv[7])
            min_publishing_interval = int(sys.argv[8])
        except:
            print("When running OPCUA you need to provide extra arguments about settings of PLC:"
             "min_sampling_interval and min_publishing_interval")
            sys.exit()

    print(f"Using module {module}")
    print(f"Using device_number {device_number}")
    print(f"Number of reads {number_of_read}")
    print(f"Save to file {save_to_file}")
    print(f"File number {file_num}")
    print(f"Run from docker?  {from_docker}")

    if module == OPCUA:
        print(f"Min sampling interval {min_sampling_interval}")
        print(f"Min publishing interval  {min_publishing_interval}")
        run(module, device_number, number_of_read, 
            print_result_dict=True, save_to_file=save_to_file, from_docker=from_docker, file_num=file_num,
            min_sampling_interval=min_sampling_interval, min_publishing_interval=min_publishing_interval)

    else:
        run(module, device_number, number_of_read, 
            print_result_dict=True, save_to_file=save_to_file, from_docker=from_docker, file_num=file_num)
