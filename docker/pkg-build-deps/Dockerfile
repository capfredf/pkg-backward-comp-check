FROM ubuntu:20.04
RUN apt-get update -y
RUN apt-get install ca-certificates tzdata -y
RUN apt-get update -y
RUN apt-get install libglib2.0-0 -y
RUN apt-get install gcc -y
RUN apt-get install sqlite3 -y
RUN apt-get install libcairo2-dev -y
RUN apt-get install xvfb -y
RUN apt-get install xterm -y
RUN apt-get install libpango-1.0-0 -y
RUN apt-get install libpangocairo-1.0-0 -y
RUN apt-get install libjpeg-dev -y
ENTRYPOINT ["/bin/bash"]
