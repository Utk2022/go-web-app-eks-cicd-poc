1. Pulled mentioned images csvserver & prometheous:

root@ub20-50-6-206:~# docker pull infracloudio/csvserver:latest
latest: Pulling from infracloudio/csvserver
53806b9086b8: Pull complete

root@ub20-50-6-206:~# docker pull prom/prometheus:v2.45.2
v2.45.2: Pulling from prom/prometheus
9fa9226be034: Pull complete

root@ub20-50-6-206:~# docker images | grep infracloudio
infracloudio/csvserver       latest                  54e5b35bc16f   12 months ago   215MB
root@ub20-50-6-206:~#
root@ub20-50-6-206:~# docker images | grep prom
prom/prometheus              v2.45.2                 9c9cea65ba17   12 months ago   238MB
root@ub20-50-6-206:~#

2. Cloned Github repository for a csvserver source code:

root@ub20-50-6-206:/opt# git clone https://github.com/infracloudio/csvserver.git
Cloning into 'csvserver'...
remote: Enumerating objects: 30, done.
remote: Counting objects: 100% (30/30), done.

3. As per mentioned steps for activate the csvserver I have ran the container & found the below error:

root@ub20-50-6-206:~# docker run -it infracloudio/csvserver:latest
2024/12/19 11:54:57 error while reading the file "/csvserver/inputdata": open /csvserver/inputdata: no such file or directory
root@ub20-50-6-206:~#

Verified the same error from container logs as well:
root@ub20-50-6-206:~# docker logs 0f3dea1de458
2024/12/19 12:06:34 error while reading the file "/csvserver/inputdata": open /csvserver/inputdata: no such file or directory
root@ub20-50-6-206:~#

4. Now, as per the requirement I built a gencsv.sh script & put the script in /csvserver/solution directory:
#!/bin/bash

# Check if two arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <first_index> <second_index>"
    exit 1
fi

# Read the start and end index from arguments
first_index=$1
second_index=$2

# Check if start_index is less than or equal to end_index
if [ $first_index -gt $second_index ]; then
    echo "Error: first_index must be less than or equal to the second_index."
    exit 1
fi

# Generate the file inputFile
output_file="inputFile"

# Remove the file if it already exists
rm -f "$output_file"

# Loop from start_index to end_index and write to the output file
for i in `seq $first_index $second_index`;
do
    # Generate a random number between 1 and 100
    random_number=$(( RANDOM % 1000 + 1 ))
    # Write the index and the random number to the file
    echo "$i, $random_number" >> "$output_file"
done

5. Now ran the container with "csvserver" again and it ran successfully.

root@ub20-50-6-206:~# docker run -d -v /inputFile:/csvserver/inputdata --name csvserver infracloudio/csvserver:latest
a6b3258dc8d42e2971c61e6f9e3d2b67d2d859a48d0229bab32c05303a856e49
root@ub20-50-6-206:~#
root@ub20-50-6-206:~# 
root@ub20-50-6-206:~# docker ps
CONTAINER ID   IMAGE                           COMMAND                  CREATED         STATUS         PORTS                     NAMES
a6b3258dc8d4   infracloudio/csvserver:latest   "/csvserver/csvserver"   3 seconds ago   Up 2 seconds   9300/tcp, 0.0.0.0:9300    csvserver
root@ub20-50-6-206:~#

6. Validated the container port(9300) by going into the container also, please consider that we can also verify the container port in the PORTS column of the docker ps command output.

root@ub20-50-6-206:~# docker exec -it csvserver sh
sh-4.4#
sh-4.4#
sh-4.4# netstat -apn
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 0.0.0.0:9300            0.0.0.0:*               LISTEN      1/csvserver
Active UNIX domain sockets (servers and established)
Proto RefCnt Flags       Type       State         I-Node   PID/Program name     Path
Active Bluetooth connections (servers and established)
Proto  Destination       Source            State         PSM DCID   SCID      IMTU    OMTU Security
Proto  Destination       Source            State     Channel
sh-4.4#
sh-4.4#

7. Now, stopped the currently running container and remove the container by hitting the following commands respectively.

docker container stop csvserver

docker container rm csvserver

8.As per the mentioned steps in the document ran the container again with "Orange" as enviornment variable, 9300 as container port and 9393 as a host port. 

root@ub20-50-6-206:~# docker run -d -v /inputFile:/csvserver/inputdata -e CSVSERVER_BORDER=Orange -p 9393:9300 --name csvserver infracloudio/csvserver
:latest
59bc048f9a47cda87ebf534bf41d71fe549b37a737802a78d0a5601bf7b8380f
root@ub20-50-6-206:~#
root@ub20-50-6-206:~#
root@ub20-50-6-206:~# docker ps
CONTAINER ID   IMAGE                           COMMAND                  CREATED         STATUS         PORTS                    NAMES
59bc048f9a47   infracloudio/csvserver:latest   "/csvserver/csvserver"   3 seconds ago   Up 2 seconds   0.0.0.0:9393->9300/tcp   csvserver
root@ub20-50-6-206:~#

9. Validated the output by hitting the URL: http://10.50.6.206:9393/
