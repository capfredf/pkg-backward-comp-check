FROM capfredf/pkg-build-min:latest
RUN apt-get update -y
RUN apt-get install libglib
RUN apt-get install ca-certificates tzdata -y
RUN apt-get install gcc -y
RUN apt-get install xvfb -y
RUN apt-get install xterm -y
ENTRYPOINT ["/bin/bash"]
