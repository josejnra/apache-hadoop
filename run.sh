# build
docker build -t hadoop:1.0 .

# run
docker run -it --rm --name hadoop -p 50070:50070 -p 8088:8088 -p 50075:50075 -p 50030:50030 -p 50060:50060 -p 9000:9000 hadoop:1.0
