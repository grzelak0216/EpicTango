# #!/bin/sh

python3 measure_time_singlebit_to_device.py opcua 0 1000 save no 0 100 200
python3 measure_time_singlebit_to_device.py opcua 0 1000 save no 1 100 200
python3 measure_time_singlebit_to_device.py opcua 0 1000 save no 2 100 200

python3 measure_time_singlebit_to_device.py opcua 1 1000 save no 0 100 200
python3 measure_time_singlebit_to_device.py opcua 1 1000 save no 1 100 200
python3 measure_time_singlebit_to_device.py opcua 1 1000 save no 2 100 200

# python3 measure_time_singlebit_to_device.py opcua 2 1000 save no 0 100 200
# python3 measure_time_singlebit_to_device.py opcua 2 1000 save no 1 100 200
# python3 measure_time_singlebit_to_device.py opcua 2 1000 save no 2 100 200

# python3 measure_time_singlebit_to_device.py opcua 3 1000 save no 0 100 200
# python3 measure_time_singlebit_to_device.py opcua 3 1000 save no 1 100 200
# python3 measure_time_singlebit_to_device.py opcua 3 1000 save no 2 100 200

# python3 measure_time_singlebit_to_device.py opcua 0 1000 yes no 0 100 200
# python3 measure_time_singlebit_to_device.py opcua 0 1000 yes no 1 100 200
# python3 measure_time_singlebit_to_device.py opcua 0 1000 yes no 2 100 200

# python3 measure_time_critical_data_unicast.py opcua single 0 s 1000 save no 0 100 200
# python3 measure_time_critical_data_unicast.py opcua single 0 s 1000 save no 1 100 200 
# python3 measure_time_critical_data_unicast.py opcua single 0 s 1000 save no 2 100 200

# python3 measure_time_critical_data_unicast.py opcua single 1 s 1000 save no 0 100 200
# python3 measure_time_critical_data_unicast.py opcua single 1 s 1000 save no 1 100 200
# python3 measure_time_critical_data_unicast.py opcua single 1 s 1000 save no 2 100 200

# python3 measure_time_critical_data_unicast.py opcua multi 2 s 1000 save no 0 100 200
# python3 measure_time_critical_data_unicast.py opcua multi 2 s 1000 save no 1 100 200
# python3 measure_time_critical_data_unicast.py opcua multi 2 s 1000 save no 2 100 200

# python3 measure_time_critical_data_unicast.py opcua multi 3 s 1000 save no 0 100 200
# python3 measure_time_critical_data_unicast.py opcua multi 3 s 1000 save no 1 100 200
# python3 measure_time_critical_data_unicast.py opcua multi 3 s 1000 save no 2 100 200

# python3 measure_time_critical_data_unicast.py opcua single 0 m 1000 save no 0 100 200
# python3 measure_time_critical_data_unicast.py opcua single 0 m 1000 save no 1 100 200
# python3 measure_time_critical_data_unicast.py opcua single 0 m 1000 save no 2 100 200

# python3 measure_time_critical_data_unicast.py opcua single 1 m 1000 save no 0 100 200
# python3 measure_time_critical_data_unicast.py opcua single 1 m 1000 save no 1 100 200
# python3 measure_time_critical_data_unicast.py opcua single 1 m 1000 save no 2 100 200

# python3 measure_time_critical_data_unicast.py opcua multi 2 m 1000 save no 0 100 200
# python3 measure_time_critical_data_unicast.py opcua multi 2 m 1000 save no 1 100 200
# python3 measure_time_critical_data_unicast.py opcua multi 2 m 1000 save no 2 100 200

# python3 measure_time_critical_data_unicast.py opcua multi 3 m 1000 save no 0 100 200
# python3 measure_time_critical_data_unicast.py opcua multi 3 m 1000 save no 1 100 200
# python3 measure_time_critical_data_unicast.py opcua multi 3 m 1000 save no 2 100 200

# python3 measure_time_not_critical_data_unicast.py opcua single 0 s 1000 save no 0 100 200
# python3 measure_time_not_critical_data_unicast.py opcua single 0 s 1000 save no 1 100 200
# python3 measure_time_not_critical_data_unicast.py opcua single 0 s 1000 save no 2 100 200

# python3 measure_time_not_critical_data_unicast.py opcua single 1 s 1000 save no 0 100 200
# python3 measure_time_not_critical_data_unicast.py opcua single 1 s 1000 save no 1 100 200
# python3 measure_time_not_critical_data_unicast.py opcua single 1 s 1000 save no 2 100 200

# python3 measure_time_not_critical_data_unicast.py opcua multi 2 s 1000 save no 0 100 200
# python3 measure_time_not_critical_data_unicast.py opcua multi 2 s 1000 save no 1 100 200
# python3 measure_time_not_critical_data_unicast.py opcua multi 2 s 1000 save no 2 100 200

# python3 measure_time_not_critical_data_unicast.py opcua multi 3 s 1000 save no 0 100 200
# python3 measure_time_not_critical_data_unicast.py opcua multi 3 s 1000 save no 1 100 200
# python3 measure_time_not_critical_data_unicast.py opcua multi 3 s 1000 save no 2 100 200

# python3 measure_time_not_critical_data_unicast.py opcua single 0 a 1000 save no 0 100 200
# python3 measure_time_not_critical_data_unicast.py opcua single 0 a 1000 save no 1 100 200
# python3 measure_time_not_critical_data_unicast.py opcua single 0 a 1000 save no 2 100 200

# python3 measure_time_not_critical_data_unicast.py opcua single 1 a 1000 save no 0 100 200
# python3 measure_time_not_critical_data_unicast.py opcua single 1 a 1000 save no 1 100 200
# python3 measure_time_not_critical_data_unicast.py opcua single 1 a 1000 save no 2 100 200

# python3 measure_time_not_critical_data_unicast.py opcua multi 2 a 1000 save no 0 100 200
# python3 measure_time_not_critical_data_unicast.py opcua multi 2 a 1000 save no 1 100 200
# python3 measure_time_not_critical_data_unicast.py opcua multi 2 a 1000 save no 2 100 200

# python3 measure_time_not_critical_data_unicast.py opcua multi 3 a 1000 save no 0 100 200
# python3 measure_time_not_critical_data_unicast.py opcua multi 3 a 1000 save no 1 100 200
# python3 measure_time_not_critical_data_unicast.py opcua multi 3 a 1000 save no 2 100 200

# python3 measure_time_critical_data_unicast.py opcua multi 5 s 1000 save no 0 100 200
# python3 measure_time_critical_data_unicast.py opcua multi 5 s 1000 save no 1 100 200
# python3 measure_time_critical_data_unicast.py opcua multi 5 s 1000 save no 2 100 200

# python3 measure_time_critical_data_unicast.py opcua multi 5 m 1000 save no 0 100 200
# python3 measure_time_critical_data_unicast.py opcua multi 5 m 1000 save no 1 100 200
# python3 measure_time_critical_data_unicast.py opcua multi 5 m 1000 save no 2 100 200

# python3 measure_time_not_critical_data_unicast.py opcua multi 5 s 1000 save no 0 100 200
# python3 measure_time_not_critical_data_unicast.py opcua multi 5 s 1000 save no 1 100 200
# python3 measure_time_not_critical_data_unicast.py opcua multi 5 s 1000 save no 2 100 200

# python3 measure_time_not_critical_data_unicast.py opcua multi 5 a 1000 save no 0 100 200
# python3 measure_time_not_critical_data_unicast.py opcua multi 5 a 1000 save no 1 100 200
# python3 measure_time_not_critical_data_unicast.py opcua multi 5 a 1000 save no 2 100 200

# python3 measure_time_critical_data_unicast.py opcua multi 8 s 1000 save no 0 100 200
# python3 measure_time_critical_data_unicast.py opcua multi 8 s 1000 save no 1 100 200
# python3 measure_time_critical_data_unicast.py opcua multi 8 s 1000 save no 2 100 200

# python3 measure_time_critical_data_unicast.py opcua multi 8 m 1000 save no 0 100 200
# python3 measure_time_critical_data_unicast.py opcua multi 8 m 1000 save no 1 100 200
# python3 measure_time_critical_data_unicast.py opcua multi 8 m 1000 save no 2 100 200

# python3 measure_time_not_critical_data_unicast.py opcua multi 8 s 1000 save no 0 100 200
# python3 measure_time_not_critical_data_unicast.py opcua multi 8 s 1000 save no 1 100 200
# python3 measure_time_not_critical_data_unicast.py opcua multi 8 s 1000 save no 2 100 200

# python3 measure_time_not_critical_data_unicast.py opcua multi 8 a 1000 save no 0 100 200
# python3 measure_time_not_critical_data_unicast.py opcua multi 8 a 1000 save no 1 100 200
# python3 measure_time_not_critical_data_unicast.py opcua multi 8 a 1000 save no 2 100 200

# python3 measure_time_critical_data_unicast.py opcua multi 12 s 1000 save no 0 100 200
# python3 measure_time_critical_data_unicast.py opcua multi 12 s 1000 save no 1 100 200
# python3 measure_time_critical_data_unicast.py opcua multi 12 s 1000 save no 2 100 200

# python3 measure_time_critical_data_unicast.py opcua multi 12 m 1000 save no 0 100 200
# python3 measure_time_critical_data_unicast.py opcua multi 12 m 1000 save no 1 100 200
# python3 measure_time_critical_data_unicast.py opcua multi 12 m 1000 save no 2 100 200

# python3 measure_time_not_critical_data_unicast.py opcua multi 12 s 1000 save no 0 100 200
# python3 measure_time_not_critical_data_unicast.py opcua multi 12 s 1000 save no 1 100 200
# python3 measure_time_not_critical_data_unicast.py opcua multi 12 s 1000 save no 2 100 200

# python3 measure_time_not_critical_data_unicast.py opcua multi 12 a 1000 save no 0 100 200
# python3 measure_time_not_critical_data_unicast.py opcua multi 12 a 1000 save no 1 100 200
# python3 measure_time_not_critical_data_unicast.py opcua multi 12 a 1000 save no 2 100 200