from datetime import datetime

from flask import flash, redirect, render_template, request
from flask_mail import Message
from flask_login import login_required, current_user

from backend import app, db, mail
from backend.models import Members
from backend.models.members import OrgMembers, MemberTypes

app.api_manager.create_api(
    Members,
    methods=['GET', 'POST', 'PATCH', 'DELETE'],
    collection_name='members'
)


@app.route('/confirm-membership/<id>')
def confirm_membership(id):
    org_id = app.config['ORG_ID']
    member = Members.query.filter_by(id=id).one()

    pending_member_type = MemberTypes.query.filter_by(description='Pending').one()

    already_confirmed = [
        org_member for org_member
        in member.organisations
        if org_member.member_type.description ==
        pending_member_type.description
        ]

    if already_confirmed:
        message = 'Already Confirmed!'
    else:
        org_member = OrgMembers(
                member_id=id,
                org_id=org_id,
                member_type=pending_member_type,
                start_date=datetime.now()
        )
        db.session.add(org_member)
        db.session.commit()
        message = 'Application Confirmed'

    return render_template('confirmed.html', message=message)


@app.route('/approve-members')
def approve_members():
    pending_approval = Members.query.join(OrgMembers).\
        filter(OrgMembers.expiry is None).join(MemberTypes).\
        filter(MemberTypes.description == 'Pending').all()

    return render_template('approve_members.html', members=pending_approval)


@app.route('/approve-member/<id>')
def approve_member(id):
    member = Members.query.get(id)

    approved_member_type = MemberTypes.query.filter_by(
            description='Approved').one()

    for org in member.organisations:
        if org.member_type.description == 'Pending':
            org.expires = datetime.now()

    member.organisations.append(
            OrgMembers(
                member_type=approved_member_type,
                org_id=1,  # TODO: this should not be hard coded
                start_date=datetime.now()
            )
    )

    flash('Member ({member.first_name} {member.last_name}) has been approved'.
          format(member=member))

    message_body = render_template(
        'mail/membership_approved.tpl',
        member=member
    )
    subject = "Your application for membership of " + \
              "{org_name} has been approved"

    subject = subject.format(org_name='Linux Australia')
    mail.send(
        Message(
            subject=subject,
            body=message_body,
            recipients=[member.email]
        )
    )

    return redirect('/approve-members')


@app.route('/profile', methods=['POST', 'GET'])
@login_required
def profile():
    from hashlib import md5
    import random
    import string

    from backend.forms import ProfileForm
    from backend.models.members import Passwd

    member = Members.query.get(current_user.id)
    if request.method == 'POST':
        form = ProfileForm(request.form)
    else:
        form = ProfileForm()
        form.id.data = member.id
        form.email.data = member.email
        form.first_name.data = member.first_name
        form.middle_name.data = member.middle_name
        form.last_name.data = member.last_name
        form.DOB.data = member.DOB
        form.sex.data = member.sex
        form.address1.data = member.address1
        form.address2.data = member.address2
        form.suburb.data = member.suburb
        form.postcode.data = member.postcode
        form.state.data = member.state
        form.country.data = member.country
        form.phone_home.data = member.phone_home
        form.phone_mobile.data = member.phone_mobile

    if request.method == 'POST' and form.validate_on_submit():
        flash('Profile edited')

        if form.id.data:
            member = Members.query.get(form.id.data)
        else:
            member = Members()

        member.first_name = form.first_name.data
        member.middle_name = form.middle_name.data
        member.last_name = form.last_name.data
        member.DOB = form.DOB.data
        member.sex = form.sex.data
        member.address1 = form.address1.data
        member.address2 = form.address2.data
        member.suburb = form.suburb.data
        member.postcode = form.postcode.data
        member.state = form.state.data
        member.country = form.country.data
        member.email = form.email.data
        member.phone_home = form.phone_home.data
        member.phone_mobile = form.phone_mobile.data

        if form.password.data:
            salt = ''.join(random.SystemRandom().choice(
                    string.ascii_uppercase + string.digits
            ) for _ in range(5))
            member.passwd[0].salt = salt
            member.passwd[0].password = md5(
                                    salt.encode() +
                                    form.password.data.encode()
                            ).hexdigest()


        db.session.commit()

    return render_template('profile.html', form=form)
# @app.route('/members')
# def index():
#     members = []
#     for member in app.session.query(app.Members).all():
#         if member.date_entered:
#             date_entered = member.date_entered.strftime('%Y-%m-%d %H:%M:%s')
#         else:
#             date_entered = None
#
#         members.append({
#             'id':member.id,
#             'date_entered': date_entered,
#             'first_name': member.first_name, 'middle_name':member.middle_name,
#             'last_name': member.last_name,
#             'DOB': member.DOB.strftime('%Y-%m-%d HH:mm:ss') \
#                        if member.DOB else None,
#             'sex': member.sex,
#             'address1': member.address1, 'address2':member.address2,
#             'suburb': member.suburb, 'postcode':member.postcode,
#             'state': member.state, 'country':member.country,
#             'email': member.email, 'phone_home':member.phone_home,
#             'phone_mobile': member.phone_mobile
#         })
#     return json.dumps(members)
#
