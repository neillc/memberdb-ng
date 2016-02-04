from datetime import datetime
import json
from flask import flash, redirect, render_template
from flask_mail import Message

from backend import app, db, mail
from backend.models import Election

@app.route('/elections')
def elections():
    elections = Election.query.order_by(Election.start_advertising).all()

    return render_template('elections.html', elections=elections)
