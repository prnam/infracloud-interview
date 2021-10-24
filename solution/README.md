# Solution

## Part-I

- Running `docker run infracloudio/csvserver:latest` command resulted in an error `2021/10/23 17:13:41 error while reading the file "/csvserver/inputdata": open /csvserver/inputdata: no such file or directory`. From the error message we can understand that this container needs a file.
- With help of 3rd instruction in the assignment, I created script `gencsv.sh` to generate `N` entries and save it with filename `inputFile`.
- Executing `./gencsv.sh` will generate default 10 entries, while `./gencsv.sh N`, where N is valid not zero, non negative integer will generate `N` entries in `inputFile`
- With help of 4th instruction in the assignment, I re-attempt to create a container with necessary parameters such as - run in background, bind the volume where the `inputFile` is present to containers `/csvserver/inputdata` and infracloud image that is pulled. Command used is pasted below for your reference.

```console
sudo docker run -d -v ${PWD}/inputFile:/csvserver/inputdata infracloudio/csvserver:latest
```
> **Note**: Executing the docker command above, must be from directory where `inputFile` is present as it uses/instructs `PWD` (present working directory) is where `inputFile` resides
- The 5th instruction is to get port number that conatiner is running by gaining shell access. So I have used `docker exec` for this step and here is the command used and result. You can also get port details by executing `docker ps -a` command and navigating port section of your container.

```console
sudo docker exec 3fbdda13e445 netstat -tulnp
```
```console
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp6       0      0 :::9300                 :::*                    LISTEN      1/csvserver        
```
- The 6th instruction is to make application accessible on port `9393` and set environment variable `CSVSERVER_BORDER` to have value `Orange` by extending command used for 4th instruction and below or `part-1-cmd` file content is that extended command on how it can be achieved.

```console
sudo docker run -dp 9393:9300 -v ${PWD}/inputFile:/csvserver/inputdata -e CSVSERVER_BORDER=Orange infracloudio/csvserver:latest
```
```
CONTAINER ID   IMAGE                           COMMAND                  CREATED          STATUS          PORTS                                                 NAMES
c25917c3b147   infracloudio/csvserver:latest   "/csvserver/csvserver"   2 minutes ago   Up 2 minutes               0.0.0.0:9393->9300/tcp, :::9393->9300/tcp   romantic_mendel
```
> **Note**: Executing the docker command in part-1-cmd or above, must be from directory where `inputFile` is present as it uses/instructs `PWD` (present working directory) is where `inputFile` resides

- Ran `curl -o ./part-1-output http://localhost:9393/raw` to generate `part-1-output`. File uploaded in `solution` directory.
- Ran  `sudo docker logs [container_id] >& part-1-logs` to save log info. `part-1-logs` file uploaded in `solition` directory.

## Part-II

In order to create and run the `docker-compose` file for `Part-I`, we need to make sure we have everything mentioned in it, such as     
- image: because we have pulled image earlier and did not delete the image we can assume it is present if not it will pulled provided system is exposed to internet or atleast registry domain, 
- dependenices: `inputFile` is generated and located where the `docker-compose.yml` file is present, 
- ports: `9393` or `9300` is not used by any services,
- compose file: `docker-compose.yml` file is present in your present working directory and
- `docker-compose` executable is installed along with `docker-ce` engine (most linux distros needs manual install)

If all the above is satisifed; run the below command to verify if file is as per the standard syntax

```console
sudo docker-compose -f docker-compose.yml config
```
If there is no error thrown, then please run the below command to get the conatiners running
```console
sudo docker-compose up -d
```
OR (based on your `docker-compose` version)
```console
sudo docker compose up -d
```
You can verfiy if conatiners are running by checking `docker ps -a` output or accessing the published port of the host through browser

```
http://localhost:9393
```
OR (for outside host i.e from your client machine to access over your favourite browser)
```
http://<host-ip-address>:9393
```
- Run `curl -o ./part-1-output http://localhost:9393/raw` to generate `part-1-output` file.
- Run `sudo docker logs [container_id] >& part-1-logs` to save log info into `part-1-logs` file.
- To bring down the container, run the below command from directory where the `docker-compose.yml` was present while you started it.
```console
sudo docker-compose down
```
