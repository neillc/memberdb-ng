from hashlib import md5

from flask.ext.wtf import Form
from wtforms import DateField, StringField, PasswordField, HiddenField
from wtforms.validators import DataRequired, Email, Length
from sqlalchemy.orm.exc import NoResultFound

from backend.models.members import Members


class LoginForm(Form):
    email = StringField('email', validators=[DataRequired()])
    password = PasswordField('password', validators=[DataRequired()])
    user_id = None

    # noinspection PyMethodOverriding
    def validate(self):
        invalid_login = 'Email address or password invalid'

        if not Form.validate(self):
            return False

        try:
            member = Members.query.filter_by(email=self.email.data).one()
            password = member.passwd[0].password
            salt = member.passwd[0].salt.encode('utf-8')

            hashed_pw = md5(salt + self.password.data.encode()).hexdigest()
            if password != hashed_pw:
                self.email.errors.append(invalid_login)
                return False

            self.user_id = member.id

        except NoResultFound:
            self.email.errors.append(invalid_login)
            return False

        return True


class SignupForm(Form):
    email = StringField('email', validators=[DataRequired(), Email()])
    password = PasswordField(
        'password',
        validators=[DataRequired(),
                    Length(min=8, max=100)]
    )
    first_name = StringField('first_name', validators=[DataRequired()])
    middle_name = StringField('middle_name')
    last_name = StringField('last_name', validators=[DataRequired()])
    dob = DateField('dob', validators=[DataRequired()])
    sex = StringField('sex', validators=[DataRequired()])
    address1 = StringField('address1', validators=[DataRequired()])
    address2 = StringField('address2')
    suburb = StringField('suburb', validators=[DataRequired()])
    postcode = StringField('postcode', validators=[DataRequired()])
    state = StringField('state', validators=[DataRequired()])
    country = StringField('country', validators=[DataRequired()])
    phone_home = StringField('phone_home')
    phone_mobile = StringField('phone_mobile')


class ProfileForm(Form):
    id = HiddenField('id')
    email = StringField('email', validators=[DataRequired(), Email()])
    password = PasswordField(
        'password',
    )
    confirm_password = PasswordField(
        'password',
    )
    first_name = StringField('first_name', validators=[DataRequired()])
    middle_name = StringField('middle_name')
    last_name = StringField('last_name', validators=[DataRequired()])
    DOB = DateField('DOB')
    sex = StringField('sex', validators=[DataRequired()])
    address1 = StringField('address1', validators=[DataRequired()])
    address2 = StringField('address2')
    suburb = StringField('suburb', validators=[DataRequired()])
    postcode = StringField('postcode', validators=[DataRequired()])
    state = StringField('state', validators=[DataRequired()])
    country = StringField('country', validators=[DataRequired()])
    phone_home = StringField('phone_home')
    phone_mobile = StringField('phone_mobile')

    # noinspection PyMethodOverriding
    def validate(self):
        invalid_password = 'Password and Confirmation do not match'

        if not Form.validate(self):
            return False

        if self.password.data != self.confirm_password.data:
            self.password.errors.append(invalid_password)
            return False

        return True
