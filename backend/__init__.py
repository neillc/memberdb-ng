#!/usr/bin/env python
#
# Copyright 2014, Rackspace, US, Inc, Neill Cox

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

import functools
import logging
import time
import argparse

from flask import Flask
import flask.ext.restless
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session

import backend.settings

ALL_HTTP_METHODS = ['GET', 'HEAD', 'POST', 'PUT', 'DELETE', 'OPTIONS']

app = None

def base_app():
    global app
    app = Flask('backend')
    app.config.overrides = {}

    logging.info('Connecting to database...')
    engine = create_engine(backend.settings.db_connection)
    app.engine = engine
    base = automap_base()
    base.prepare(engine, reflect=True)

    session = Session(engine)
    app.base = base
    app.session = session
    app.Decl_Base = declarative_base()
    
    from backend.models import Members
    app.Decl_Base.metadata.create_all(app.engine)

    # Create the Flask-Restless API manager.
    app.api_manager = flask.ext.restless.APIManager(app, session=app.session)
    app.api_manager.create_api(Members, methods=['GET', 'POST', 'PATCH', 'DELETE'], collection_name='members')

    return app

    @app.route("/shutdown", methods=["POST"])   # pragma: no cover
    def shutdown():  # pragma: no cover
        logging.info('shutting down server')
        shutdown_server()
        return "server shutting down"



def abort_app():
    """
    Return error 500 on all requests 
    """
    app = base_app()
    app.config.status_code = 500

    def e500(path):
        abort(app.config.status_code)
    app.route('/', methods=ALL_HTTP_METHODS)(e500)
    return app


def garbage_app():
    """
    Return OK but with garbage content to /
    """
    app = base_app()

    def garbage(path):
        return Response("garbage response to %s" % path, status=200,
                        content_type='application/json')
    app.route('/', methods=ALL_HTTP_METHODS)(garbage)
    return app


def shutdown_server():   # pragma: no cover
    func = request.environ.get('werkzeug.server.shutdown')
    if func is None:
        raise RuntimeError('Not running with the Werkzeug Server')
    func()


def setup_logging(filename):    # pragma: no cover
    log_format = '%(asctime)s:%(levelname)s:%(filename)s(%(lineno)d) ' \
        '%(message)s'
    log_level = logging.DEBUG
    logging.basicConfig(format=log_format, level=log_level, filename=filename)
    if filename:
        print('Logging to %s' % filename)


def foreground_runner(app, *args, **kwargs):    # pragma: no cover
    # snippet for debugging w/ wingIDE:
    if __debug__:
        from os import environ
        if 'WINGDB_ACTIVE' in environ:
            app.debug = False

    app.run(*args, **kwargs)


def background_runner(app, *args, **kwargs):    # pragma: no cover
    kwargs["use_reloader"] = False

    # snippet for debugging w/ wingIDE:
    if __debug__:
        from os import environ
        if 'WINGDB_ACTIVE' in environ:
            kwargs["debug"] = False
    else:
        kwargs["debug"] = True
    process = Thread(target=app.run, args=args, kwargs=kwargs,
            daemon=False)
    process.start()
    import ipdb
    ipdb.set_trace()


def delay_response(delay):
    if has_request_context():
        if request.path.lower().startswith(''):
            logging.info('Delaying response by %s seconds', delay)
            time.sleep(delay)


def main():  # pragma: no cover
    parser = argparse.ArgumentParser(description='memberdb webapp')
    backend_target_group = parser.add_mutually_exclusive_group()
    backend_target_group.add_argument(
        '--ipdb', action='store_true',
        help='Execute in the background and start ipdb')
    backend_target_group.add_argument(
        '--simulator', action='store_true',
        help='Run against the simulator')
    backend_target_group.add_argument(
        '--abort500', action='store_true',
        help='Run against an stack that aborts with 500')
    backend_target_group.add_argument(
        '--garbage', action='store_true',
        help='Run against a stack that returns 200 but garbage content')
    parser.add_argument(
        '--delay', metavar='n', type=int, default=0,
        help='Seconds to wait before processing each request')
    parser.add_argument(
        '--port', '-P', type=int, default=8531,
        help='Port to serve the backend on')
    parser.add_argument(
        '--host', '-H', default="0.0.0.0",
        help='IP or hostname to serve on')
    parser.add_argument(
        '--log', '-l', default=None,
        help='File to log messages to')
    parser.set_defaults(simulator=True)
    args = parser.parse_args()

    runner = foreground_runner
    if args.ipdb:
        runner = background_runner

    runner_kw = {
        'host': args.host,
        'port': args.port,
        'debug': True,
        'host': '0.0.0.0'
    }

    if __debug__:
        from os import environ
        if 'WINGDB_ACTIVE' in environ:
            runner_kw["debug"] = False

    setup_logging(args.log)

    if args.abort500:
        logging.info("Backend will return 500 on every call")
        app = abort_app()
    elif args.garbage:
        logging.info("Backend returns ok but garbage content on every call")
        app = garbage_app()
    else:
        logging.info("Using real backend")
        app = base_app()

    if args.delay > 0:
        logging.info("Delaying by %s seconds prior to response" % args.delay)
        runner_kw['threaded'] = True
        app.before_request(functools.partial(delay_response, args.delay))

    import backend.views
    runner(app=app, **runner_kw)


