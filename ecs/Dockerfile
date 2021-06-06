FROM ubuntu:18.04 


RUN apt-get update && apt-get install -y wget ca-certificates \
    git curl vim python3-dev python3-pip \
    libfreetype6-dev libpng-dev libhdf5-dev


RUN mkdir -p /usr/src/app 
WORKDIR /usr/src/app 
COPY . .
RUN pip3 install -r requirements.txt
RUN apt-get update

EXPOSE 8888 8004
ENTRYPOINT ["python3", "app.py"]