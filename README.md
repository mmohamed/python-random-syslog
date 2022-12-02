# Python Random Syslog 

## Code
```python
import logging, time, socket, json, os, pysyslogclient
from rfc5424logging import Rfc5424SysLogHandler
from random import randint

appname = os.getenv('APPNAME', 'MyLogger')

if os.getenv('STD') == 'RFC5424':
    print("RFC5424 SyslogClient init - {0} - {1}/{2}".format(os.getenv('HOST', '127.0.0.1'), os.getenv('PORT', 514), os.getenv('PROTOCOL', 'TCP')))
    logger = pysyslogclient.SyslogClientRFC5424(os.getenv('HOST', '127.0.0.1'), 
        os.getenv('PORT', 514), proto=os.getenv('PROTOCOL', 'TCP'))
elif os.getenv('STD') == 'RFC3164':
    logger = pysyslogclient.SyslogClientRFC3164(os.getenv('HOST', '127.0.0.1'), 
        os.getenv('PORT', 514), proto=os.getenv('PROTOCOL', 'TCP'))
else:
    logger = logging.getLogger(appname)
    logger.setLevel(logging.INFO)
    soketType = socket.SOCK_STREAM if os.getenv('PROTOCOL', 'TCP') == 'TCP' else socket.SOCK_DGRAM
    sh = Rfc5424SysLogHandler(address=(os.getenv('HOST', '127.0.0.1'), os.getenv('PORT', 514)), socktype=soketType, msg_as_utf8=False)
    logger.addHandler(sh)

print("{0} SyslogClient init - {1} - {2}/{3}".format(os.getenv('STD', 'RFC5424-Handler'), os.getenv('HOST', '127.0.0.1'), os.getenv('PORT', 514), os.getenv('PROTOCOL', 'TCP')))


counter = 0
sleep = 0

log = {"message": None}
for name, value in os.environ.items():
    if name.startswith('LOG_'):
        log[name.lower()[4:]] = value
pattern = "[{0}] This is a {1} msg number {2} after {3}s"

while True:
    msg_type = randint(0, 4)
    if(msg_type == 0):
        log["message"] = pattern.format(appname, "debug", counter, sleep)
        if os.getenv('STD') == 'RFC5424' or os.getenv('STD') == 'RFC3164':
            logger.log(json.dumps(log),	severity=pysyslogclient.SEV_DEBUG , program=appname) 
        else:
            logger.debug(json.dumps(log))
    if(msg_type == 1):
        log["message"] = pattern.format(appname, "info", counter, sleep)
        if os.getenv('STD') == 'RFC5424' or os.getenv('STD') == 'RFC3164':
            logger.log(json.dumps(log),	severity=pysyslogclient.SEV_INFO , program=appname) 
        else:
            logger.info(json.dumps(log))
    if(msg_type == 2):
        log["message"] = pattern.format(appname, "warning", counter, sleep)
        if os.getenv('STD') == 'RFC5424' or os.getenv('STD') == 'RFC3164':
            logger.log(json.dumps(log),	severity=pysyslogclient.SEV_WARNING , program=appname)
        else:
            logger.warning(json.dumps(log)) 
    if(msg_type == 3):
        log["message"] = pattern.format(appname, "error", counter, sleep)
        if os.getenv('STD') == 'RFC5424' or os.getenv('STD') == 'RFC3164':
            logger.log(json.dumps(log),	severity=pysyslogclient.SEV_ERROR , program=appname) 
        else:
            logger.error(json.dumps(log))
    if(msg_type == 4):
        log["message"] = pattern.format(appname, "critical", counter, sleep)
        if os.getenv('STD') == 'RFC5424' or os.getenv('STD') == 'RFC3164':
            logger.log(json.dumps(log),	severity=pysyslogclient.SEV_CRITICAL , program=appname) 
        else:
            logger.critical(json.dumps(log))

    print(json.dumps(log))

    counter = counter + 1
    sleep = randint(0, 30)
    time.sleep(sleep)
```

---
## Build
```bash
docker buildx build --push --platform linux/arm64,linux/amd64 --tag medinvention/python-random-syslog:0.0.1 . -f Dockerfile 
```

---- 

[*More informations*](https://blog.medinvention.dev)