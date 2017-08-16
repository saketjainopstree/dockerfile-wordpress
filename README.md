# dockerfile-wordpress
step to install wordpress by dockerfile
To build the container use the command "docker build -t test ."
Check that the images is created "docker images"
Run this command "docker run -d test"
Run this command to list the container "docker ps -a"
Run this command "docker exec -it container_id /bin/bash" 
Run this command to check the id of container "docker inspect container_id | grep ip"
Do the entry of the ip of docker container into the /etc/hosts >> "ip_address  wordpress.local" 
Open the browser and open the wordpress.local
