from flask.ext.wtf import Form
from wtforms import StringField, PasswordField
from wtforms.validators import DataRequired, Email, Length


class LoginForm(Form):
    email = StringField('email', validators=[DataRequired()])
    password = PasswordField('password', validators=[DataRequired()])


class SignupForm(Form):
    email = StringField('email', validators=[DataRequired(), Email()])
    password = PasswordField(
        'password',
        validators=[DataRequired(),
                    Length(min=8, max=100)]
    )

