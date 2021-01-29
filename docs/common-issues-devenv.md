# Common issues I run in to in my development environmnent

## Debug fails to start
Error message after pressing F5 in Visual Studio 2019:
```
Starting IIS Express ...
Successfully registered URL "https://localhost:44320/" for site "AuthorsApi" application "/"
Failed to register URL "http://localhost:1288/" for site "AuthorsApi" application "/". Error description: The process cannot access the file because it is being used by another process. (0x80070020)
Registration completed for site "AuthorsApi"
IIS Express is running.
```

Error code 0x80070020 means ERROR_SHARING_VIOLATION, which in the case of IIS Express (or IIS) means that the port that it is attempting to listen on is being used by another process.

Use the netstat command to find out which application is using the port.

netstat -ao | findstr <port_number_to_search_for>
The a parameter tells netstat to display all connections and listening ports.

The o parameter tells netstat to display the process ID associated with the connection.


If that does not do the trick, check to see if the port is in the excluded port range:
netsh interface ipv4 show excludedportrange protocol=tcp
