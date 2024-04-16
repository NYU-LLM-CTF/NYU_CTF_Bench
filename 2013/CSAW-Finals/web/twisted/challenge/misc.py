
from twisted.python import log

stages = {}

def reset(ipaddr):
    log.msg('%s reset back to stage 1' % ipaddr)
    stages.pop(ipaddr, None)
