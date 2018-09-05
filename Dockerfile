FROM python:2-alpine3.6

RUN mkdir -p /opt/yair/config/

COPY requirements.txt /opt/yair/
COPY yair.py /opt/yair/yair.py
COPY config.yaml /opt/yair/config/config.yaml

RUN pip install --no-cache-dir -r /opt/yair/requirements.txt

ENTRYPOINT ["/opt/yair/yair.py"]
CMD ""
