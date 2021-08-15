## How to run

```shell
docker-compose up -d
```

If you want to scale datanodes, first of all you need to comment the options `container_name` and `ports`.
```shell
docker-compose up --scale datanode=2 -d
```
