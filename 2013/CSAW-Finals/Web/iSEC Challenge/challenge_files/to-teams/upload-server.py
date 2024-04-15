#!/usr/bin/env python

import threading
import tornado.httpserver
import tornado.ioloop
import tornado.web

from servercheck import getUpdate

class UpdateCheckWorker(threading.Thread):
   def __init__(self, callback=None, *args, **kwargs):
        super(UpdateCheckWorker, self).__init__(*args, **kwargs)
        self.callback = callback

   def run(self):
      self.callback(getUpdate("/home/ubuntu/csaw/uploads/uploaded_config.xml"))

"""
Accept a POST of the following form:

<?xml version="1.0" encoding="UTF-8" ?> 
<config>
	<updateServer>fiascoaverted.com</updateServer>
	<currentVersion>1.3.1</currentVersion>
    <updateMethod>latest</updateMethod>
</config>
"""
class UpdateHandler(tornado.web.RequestHandler):
    @tornado.web.asynchronous
    def post(self):
        print "Got request"
        config = self.request.body
        output_file = open("/home/ubuntu/csaw/uploads/uploaded_config.xml", 'w')
        output_file.write(config)
        output_file.close()
        UpdateCheckWorker(self._worker_done).start()
    def _worker_done(self, response):
       self.finish(response)

def main():
    app = tornado.web.Application([
            (r"/update", UpdateHandler)
            ])
    app.listen(80, "0.0.0.0")
    tornado.ioloop.IOLoop.instance().start()

if __name__ == "__main__":
    main()
