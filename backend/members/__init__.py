#!/usr/bin/env python
#
# Copyright 2014, Rackspace, US, Inc, Neill Cox
#
# This file is part of memberdb.
#
# memberdb is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# memberdb is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with memberdb.  If not, see <http://www.gnu.org/licenses/>.

import logging

# from flask import has_request_context, Flask, abort, Response, request
from flask import request
from backend import app


def shutdown_server():
    func = request.environ.get('werkzeug.server.shutdown')
    if func is None:
        raise RuntimeError('Not running with the Werkzeug Server')
    func()


@app.route("/shutdown", methods=["POST"])   # pragma: no cover
def shutdown():  # pragma: no cover
    logging.info('shutting down server')
    shutdown_server()
    return "server shutting down"

