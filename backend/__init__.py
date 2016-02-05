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

import logging
import argparse
from flask import Flask
from flask_admin import Admin
from flask_admin.contrib.sqla import ModelView

from flask.ext.login import (
    login_required,
    LoginManager,
    logout_user,
    UserMixin
    )

from flask_sqlalchemy import SQLAlchemy
from flask_mail import Mail
# import backend.models


ALL_HTTP_METHODS = ['GET', 'HEAD', 'POST', 'PUT', 'DELETE', 'OPTIONS']

app = Flask('backend')
db = None
admin = None
mail = None

login_manager = LoginManager()
login_manager.init_app(app)


class UserNotFoundError(Exception):
    pass


# noinspection PyShadowingBuiltins
class User(UserMixin):

    def __init__(self, id):
        from backend.models.members import Members
        from sqlalchemy.orm.exc import NoResultFound

        self.id = None
        self.email = None

        try:
            member = Members.query.filter_by(id=id).one()
            self.id = member.id
            self.email = member.email
        except NoResultFound:
            pass

    def get_id(self):
        return self.id

    @classmethod
    def get(cls, user_id):
        try:
            return cls(user_id)
        except UserNotFoundError:
            return None


@login_manager.user_loader
def load_user(user_id):
    return User.get(user_id)


def base_app():
    global app, db, admin, mail
    app.config.from_object('backend.settings')
    db = SQLAlchemy(app)
    mail = Mail(app)

    # if 'MEMBERDB_SETTINGS' in os.environ:
    #     app.config.from_envvar('MEMBERDB_SETTINGS')

    from backend.models import Members
    from flask.ext.restless import APIManager
    # Create the Flask-Restless API manager.
    app.api_manager = APIManager(app, flask_sqlalchemy_db=db)
    app.api_manager.create_api(
        Members,
        methods=['GET', 'POST', 'PATCH', 'DELETE'],
        collection_name='members')

    admin = create_admin_views(app)
    return app


def create_admin_views(my_app):
    from backend import models

    admin_app = Admin(my_app, name='MemberDBNG', template_mode='bootstrap3')

    for model in [
        models.Activities,
        models.Election,
        models.ElectionCandidate,
        models.ElectionCandidateNomination,
        models.ElectionPosition,
        models.ElectionVote,
        models.Events,
        models.EventHostOrgs,
        models.EventOrganisers,
        models.EventSignup,
        models.EventSignupStatus,
        models.EventTypes,
        models.GroupMembers,
        models.Groups,
        models.Log,
        models.Members,
        models.MemberTypes,
        models.members.MemberQualifications,
        models.Organisation,
        models.OrganisationOrganisationTypes,
        models.OrganisationRelationships,
        models.OrganisationRelationTypes,
        models.OrganisationTypes,
        models.members.OrgMembers,
        models.Passwd,
        models.Permissions,
        models.Positions,
        models.PositionsHeld,
        models.SystemMessages,
        models.Token,
    ]:
        admin_app.add_view(ModelView(model, db.session))

    return admin_app


def setup_logging(filename):    # pragma: no cover
    log_format = '%(asctime)s:%(levelname)s:%(filename)s(%(lineno)d) ' \
        '%(message)s'
    log_level = logging.DEBUG
    logging.basicConfig(format=log_format, level=log_level, filename=filename)
    if filename:
        print('Logging to %s' % filename)


def main():  # pragma: no cover
    global app

    parser = argparse.ArgumentParser(description='memberdb webapp')
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

    runner_kw = {
        'host': args.host,
        'port': args.port,
        'debug': True,
    }

    setup_logging(args.log)

    app = base_app()

    import backend.views

    app.run(**runner_kw)
