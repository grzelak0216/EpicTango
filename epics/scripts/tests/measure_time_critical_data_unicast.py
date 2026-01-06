import sys
import time
import json
from epics import caget, caput, pv
import numpy as np
import statistics 
from np_encoder import NpEncoder
import random

DEFAULT_READ_NUMBER = 1000

S7NODAVE = "s7nodave"
OPCUA = "opcua"
S7PLC="s7plc"

MODULES = [S7NODAVE, OPCUA, S7PLC]

SINGLE="single"
MULTI="multi"

TEST_TYPE = [SINGLE, MULTI]

def get_pv_read(module, device_list, data_type):
    if data_type.lower() == "s":
        infix="bo"
        postfix="singlebit"
    else:
        infix="ao"
        postfix="multibit"

    results=[]
    for i in device_list:
        results.append(f"{module}:{infix}{i}:critical:{postfix}:received")
    return results

    
def get_pv_write(module, device_list, data_type):
    if data_type.lower() == "s":
        infix="bo"
        postfix="singlebit"
    else:
        infix="ao"
        postfix="multibit"

    results=[]
    for i in device_list:
        results.append(f"{module}:{infix}{i}:critical:{postfix}")
    return results
    

def compute_and_save_stats(time_diffs, unicast_time, pvs_name_read_list, module, device_number, number_of_read, file_num,
                             test_type, data_type, print_result_dict=True, save_to_file=True, from_docker=False,
                             min_sampling_interval=None, min_publishing_interval=None):
    
    mean = np.mean(time_diffs)
    median = np.median(time_diffs)
    variance_val = np.var(time_diffs)
    std_val = np.std(time_diffs)
    min_val = np.amin(time_diffs)
    max_val = np.amax(time_diffs)
    coefficient_of_variation = std_val / mean

    result_dict = {}

    for entry in unicast_time:
        for variable, time_value in entry:
            if variable not in result_dict:
                result_dict[variable] = []
            result_dict[variable].append(int(time_value))

    run_result = [[key, value] for key, value in result_dict.items()]
    
    run_data = []

    for item in run_result:
        data = item[1]
        mean = np.mean(data)
        median = np.median(data)
        variance_val = np.var(data, ddof=1)
        std_val = np.std(data, ddof=1)
        min_val = np.amin(data)
        max_val = np.amax(data)
        cv = std_val / mean

        sigle_device = {
            'data': data,
            'mean': mean,
            'median': median,
            'variance_val': variance_val,
            'std_val': std_val,
            'min_val': min_val,
            'max_val': max_val,
            'cv': cv
        }

        run_data.append([item[0], sigle_device])

    results = {}
    results['sequences'] = run_data
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

    if data_type.lower() == "s":
        infix="singlebit"
    else:
        infix="multibit"

    if module == OPCUA:
        filename=f"./results/multi_devices/critical/{module}_{infix}_{device_number.replace(':', '_')}_{test_type.lower()}_{number_of_read}_{min_sampling_interval}_{min_publishing_interval}"
    else:
        filename=f"./results/multi_devices/critical/{module}_{infix}_{device_number.replace(':', '_')}_{test_type.lower()}_{number_of_read}"
 
    if from_docker:
        filename += f"_docker_{file_num}.json"
    else:
        filename += f"_{file_num}.json"

    if save_to_file:
        with open(filename, 'w') as f: 
            json.dump(results, f, indent=4, cls=NpEncoder)


def run_single(module, device_list, number_of_read, test_type, device_number, data_type, 
        print_result_dict, save_to_file, from_docker, file_num, min_sampling_interval=None, min_publishing_interval=None):
    times_array = []
    unicast_time =[]

    pvs_name_read_list =  get_pv_read(module, device_list, data_type)
    pvs_name_write_list =  get_pv_write(module, device_list, data_type)

    # val = caget(pv_name_read)
    for j in range(len(pvs_name_write_list)):
        caput(pvs_name_write_list[j], 0)
        time.sleep(0.1)
        # print(pvs_name_write_list[j])

    while len(times_array) < number_of_read:
        l = len(times_array)
        
        if l % 20 == 0:
            print(f"Run {l}")
        for i in range(0,2):
            start = time.time()
            for j in range(len(pvs_name_write_list)):
                caput(pvs_name_write_list[j], i)
            val = False
            single_run = []
            check_list = []
            while not val:
                for tmp in pvs_name_read_list:
                    if caget(tmp) == i and tmp not in check_list:
                        t = (time.time() - start) * 1000
                        single_run.append((tmp, t))
                        check_list.append(tmp)
                        print(check_list)
                val = len(single_run) == len(pvs_name_read_list)
            stop = time.time()
            time_diff = (stop - start) * 1000
            time_diff = int(time_diff)
            print(single_run)
            unicast_time.append(single_run)
            times_array.append(time_diff)
            time.sleep(0.03)
    print(unicast_time)
    compute_and_save_stats(times_array, unicast_time, pvs_name_read_list, module, device_number, number_of_read, file_num,
                            test_type, data_type, print_result_dict, save_to_file, from_docker,
                            min_sampling_interval, min_publishing_interval)

def run_multiple(module, device_list, number_of_read, test_type, device_number, data_type, 
        print_result_dict, save_to_file, from_docker, file_num, min_sampling_interval=None, min_publishing_interval=None):
    times_array = []
    unicast_time =[]

    pvs_name_read_list =  get_pv_read(module, device_list, data_type)
    pvs_name_write_list =  get_pv_write(module, device_list, data_type)

    # val = caget(pv_name_read)
    for j in range(len(pvs_name_write_list)):
        caput(pvs_name_write_list[j], 0)
        time.sleep(0.1)
        # print(pvs_name_write_list[j])

    while len(times_array) < number_of_read:
        l = len(times_array)
        
        if l % 20 == 0:
            print(f"Run {l}")
        for i in range(0,2):
            start = time.time()
            pv_val = random.randint(0, 2**10 - 1)
            for j in range(len(pvs_name_write_list)):
                caput(pvs_name_write_list[j], pv_val)
            val = False
            single_run = []
            check_list = []
            while not val:
                for tmp in pvs_name_read_list:
                    if caget(tmp) == pv_val and tmp not in check_list:
                        t = (time.time() - start) * 1000
                        single_run.append((tmp, t))
                        check_list.append(tmp)
                        print(check_list)
                val = len(single_run) == len(pvs_name_read_list)
            stop = time.time()
            time_diff = (stop - start) * 1000
            time_diff = int(time_diff)
            print(single_run)
            unicast_time.append(single_run)
            times_array.append(time_diff)
            time.sleep(0.03)
    print(unicast_time)
    compute_and_save_stats(times_array, unicast_time, pvs_name_read_list, module, device_number, number_of_read, file_num,
                            test_type, data_type, print_result_dict, save_to_file, from_docker,
                            min_sampling_interval, min_publishing_interval)                            

if __name__ == "__main__":
    if len(sys.argv) < 9:
        print("You have to pass 6 arguments")
        print("Example: python3 measure_time_singlebit.py <module> <test type> <device_number> <data type> <number_of_read> <save> <source> ")
        print("<module> = s7plc / s7nodave / opcua")
        print("<single device>  yes / multi ")
        print("<device_number> = [0, 17]")
        print("<data type> = single / multiple (s/m)")
        print("<number_of_read> = default 1000")
        print("<save> = save/no")
        print("<source> = docker/no")
        print("<file_num> = 1")
        print("<minimum_sampling> = 100")
        print("<minimum_publishing> = 200")
        sys.exit()

    module = sys.argv[1]
    test_type = sys.argv[2]
    device_number = sys.argv[3]
    data_type = sys.argv[4]
    number_of_read = sys.argv[5]
    save_to_file = sys.argv[6]
    source = sys.argv[7]
    file_num = sys.argv[8]

    try:
        number_of_read = int(sys.argv[5])
    except: 
        number_of_read = DEFAULT_READ_NUMBER

    if module not in MODULES:
        print(f"Module must be in {MODULES}")
        sys.exit()
    if test_type not in TEST_TYPE:
        print(f"Test type must be in {TEST_TYPE}")
        sys.exit()
    if int(device_number) not in range(0, 17):
        print(f"device_number must be in [0,16]")
        sys.exit()
    if test_type.lower() == "single":
        device_list = [device_number]
    else:
        device_list = np.arange(int(device_number))
    if save_to_file.strip().lower() == "save":
        save_to_file = True
    else:
        save_to_file = False
    
    print(f"SOURCE IS: {source}")
    if source.strip().lower() == "docker":
        from_docker = True
    else:
        from_docker = False

    if data_type.lower() not in ["s", "m"]:
        print("<data type> = single / multiple (s/m)")
        sys.exit()


    if module == OPCUA:
        try:
            min_sampling_interval = int(sys.argv[9])
            min_publishing_interval = int(sys.argv[10])
        except:
            print("When running OPCUA you need to provide extra arguments about settings of PLC:"
             "min_sampling_interval and min_publishing_interval")
            sys.exit()

    print(f"Using module {module}")
    print(f"Using devices {device_list}")
    print(f"Number of reads {number_of_read}")
    print(f"Save to file {save_to_file}")
    print(f"File number {file_num}")
    print(f"Run from docker?  {from_docker}")

    if module == OPCUA:
        print(f"Min sampling interval {min_sampling_interval}")
        print(f"Min publishing interval  {min_publishing_interval}")
        if data_type.lower() == "s":
            run_single(module, device_list, number_of_read, test_type, device_number, data_type, 
            print_result_dict=True, save_to_file=save_to_file, from_docker=from_docker, file_num=file_num,
            min_sampling_interval=min_sampling_interval, min_publishing_interval=min_publishing_interval)
        else:
            run_multiple(module, device_list, number_of_read, test_type, device_number, data_type, 
                print_result_dict=True, save_to_file=save_to_file, from_docker=from_docker, file_num=file_num,
                min_sampling_interval=min_sampling_interval, min_publishing_interval=min_publishing_interval)
    else:
        if data_type.lower() == "s":
            run_single(module, device_list, number_of_read, test_type, device_number, data_type, 
                print_result_dict=True, save_to_file=save_to_file, from_docker=from_docker, file_num=file_num)
        else:
            run_multiple(module, device_list, number_of_read, test_type, device_number, data_type, 
                print_result_dict=True, save_to_file=save_to_file, from_docker=from_docker, file_num=file_num)
