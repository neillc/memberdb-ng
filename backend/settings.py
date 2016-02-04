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

import os


def get_from_env(name, default, truthy=False):
    if name in os.environ:
        if truthy:
            if os.environ[name] in ['Y', 'Yes', 'True', '1', 'T']:
                return True
            else:
                return False
        return os.environ[name]
    else:
        return default


SQLALCHEMY_DATABASE_URI = get_from_env(
        'SQLALCHEMY_DATABASE_URI',
        'mysql+mysqlconnector://<user>:<password>@<ip>/<dbname>'
)

SECRET_KEY = get_from_env('SECRET_KEY', 'CHANGETHIS!!!')
PORT = get_from_env('PORT', 8531)
debug = get_from_env('debug', False, truthy=True)
HOST = get_from_env('HOST', '127.0.0.1')

WTF_CSRF_ENABLED = get_from_env('WTF_CSRF_ENABLED', True, truthy=True)

MAIL_SERVER = get_from_env('MAIL_SERVER', "changethis")
MAIL_PORT = get_from_env('MAIL_PORT', 465)
MAIL_USE_SSL = get_from_env('MAIL_USE_SSL', True, truthy=True)
MAIL_USERNAME = get_from_env('MAIL_USERNAME', "changethis")
MAIL_PASSWORD = get_from_env('MAIL_PASSWORD', "changethis")
MAIL_DEFAULT_SENDER = get_from_env(
        'MAIL_DEFAULT_SENDER',
        "changethis"
)

ORG_ID = 1
