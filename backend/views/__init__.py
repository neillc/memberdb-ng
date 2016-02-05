from datetime import datetime
from hashlib import md5
import random
import string

import backend.views.members


from flask import render_template, flash, redirect
from flask_login import login_user
from flask_mail import Message
from flask.ext.login import (
    login_required,
    logout_user
    )

from backend import app, db, User, mail
from backend.forms import LoginForm, SignupForm
from backend.models.members import Members, OrgMembers, MemberTypes, Passwd
from backend.models.orgs import Organisation

# from backend.views.admin import members, orgs
from backend.views.members import confirm_membership
from backend.views.elections import elections

@app.route("/")
def index():
    return render_template('index.html')


# @app.route("/login", methods=["POST"])
# def login():
#     user = User.get(request.form['user'])
#     if user and user.password == request.form['password']:
#         login_user(user)
#     else:
#         flash('Username or password incorrect')
#
#     return redirect(url_for('index'))


@app.route("/edit")
@login_required
def edit():
    return 'You can edit your details here'


@app.route("/logout")
def logout():
    logout_user()
    return "You have been logged out"


@app.route("/signed-up")
def signed_up():
    return (
        "Thank you for signing up. You will receive an email confirmation soon"
    )



@app.route('/login', methods=['GET', 'POST'])
def login():
    form = LoginForm()
    if form.validate_on_submit():
        flash('Login requested for email="%s", password=%s' %
              (form.email.data, form.password.data))
        user = User(form.user_id)
        login_user(user)
        flash('Logged in successfully')
        return redirect('/')
    return render_template('login.html',
                           title='Sign In',
                           form=form)


@app.route('/signup', methods=['GET', 'POST'])
def signup():
    form = SignupForm()
    if form.validate_on_submit():
        flash('Signup requested for email="%s", password=%s' %
              (form.email.data, form.password.data))

        organisation = Organisation.query.filter_by(id=1).one()
        member_type = MemberTypes.query.filter_by(
                type='Applied',
                org_id=organisation.id).one()

        member = Members(
                first_name=form.first_name.data,
                middle_name=form.middle_name.data,
                last_name=form.last_name.data,
                DOB=form.dob.data,
                sex=form.sex.data,
                address1=form.address1.data,
                address2=form.address2.data,
                suburb=form.suburb.data,
                postcode=form.postcode.data,
                state=form.state.data,
                country=form.country.data,
                email=form.email.data,
                phone_home=form.phone_home.data,
                phone_mobile=form.phone_mobile.data
        )

        start_date = datetime.now()
        expiry = datetime(
                start_date.year + 1,
                month=start_date.month,
                day=start_date.day,
                hour=start_date.hour,
                minute=start_date.minute
        )
        member.organisations.append(
                OrgMembers(
                    org_id=organisation.id,
                    member_type_id=member_type.id,
                    start_date=start_date,
                    expiry=expiry
                )
        )

        salt = ''.join(random.SystemRandom().choice(
                string.ascii_uppercase + string.digits
        ) for _ in range(5))
        member.passwd.append(
                Passwd(
                        salt=salt,
                        password=md5(
                                salt.encode() + form.password.data.encode()
                        ).hexdigest()
                )
        )

        db.session.add(member)
        db.session.commit()

        message_body = render_template(
            'mail/request_for_confirmation.tpl',
            member=member,
            now=datetime.now().strftime('%c')
        )
        subject = "Please confirm your application for membership of " + \
                  "{org_name}"

        subject = subject.format(org_name='Linux Australia')
        mail.send(
            Message(
                subject=subject,
                body=message_body,
                recipients=[member.email]
            )
        )

        return redirect('/signed-up')
    return render_template('signup.html',
                           title='Sign In',
                           form=form)
