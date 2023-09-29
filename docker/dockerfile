# default Python version, the latest of Python3
FROM python:3.10-bookworm

RUN pip install --upgrade pip>=23.2.1

COPY requirements.txt /tmp/requirements.txt    
RUN pip install -r /tmp/requirements.txt

ENV PORT_JNB=8888
RUN echo 'alias jlab="jupyter lab --ip 0.0.0.0 --port ${PORT_JNB} --no-browser --allow-root"' >> ~/.bashrc

EXPOSE ${PORT_JNB}