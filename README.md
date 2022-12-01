# Python Random Syslog 

## Code
```python
import logging, time, socket, json, os, pysyslogclient
from random import randint

if os.getenv('STD', 'RFC5424') == 'RFC5424':
    print("RFC5424 SyslogClient init - {0} - {1}/{2}".format(os.getenv('HOST', '127.0.0.1'), os.getenv('PORT', 514), os.getenv('PROTOCOL', 'TCP')))
    logger = pysyslogclient.SyslogClientRFC5424(os.getenv('HOST', '127.0.0.1'), 
        os.getenv('PORT', 514), proto=os.getenv('PROTOCOL', 'TCP'))
else:
    print("RFC3164 SyslogClient init - {0} - {1}/{2}".format(os.getenv('HOST', '127.0.0.1'), os.getenv('PORT', 514), os.getenv('PROTOCOL', 'TCP')))
    logger = pysyslogclient.SyslogClientRFC3164(os.getenv('HOST', '127.0.0.1'), 
        os.getenv('PORT', 514), proto=os.getenv('PROTOCOL', 'TCP'))

counter = 0
sleep = 0

log = {"message": None}
for name, value in os.environ.items():
    if name.startswith('LOG_'):
        log[name.lower()[4:]] = value
pattern = "This is a {0} msg number {1} after {2}s"

appname = os.getenv('APPNAME', 'MyLogger')

while True:
    msg_type = randint(0, 4)
    if(msg_type == 0):
        log["message"] = pattern.format("debug", counter, sleep)
        logger.log(json.dumps(log),	severity=pysyslogclient.SEV_DEBUG , program=appname) 
    if(msg_type == 1):
        log["message"] = pattern.format("info", counter, sleep)
        logger.log(json.dumps(log),	severity=pysyslogclient.SEV_INFO , program=appname) 
    if(msg_type == 2):
        log["message"] = pattern.format("warning", counter, sleep)
        logger.log(json.dumps(log),	severity=pysyslogclient.SEV_WARNING , program=appname) 
    if(msg_type == 3):
        log["message"] = pattern.format("error", counter, sleep)
        logger.log(json.dumps(log),	severity=pysyslogclient.SEV_ERROR , program=appname) 
    if(msg_type == 4):
        log["message"] = pattern.format("critical", counter, sleep)
        logger.log(json.dumps(log),	severity=pysyslogclient.SEV_CRITICAL , program=appname) 

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