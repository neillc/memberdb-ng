import backend.views.members


from flask import render_template, flash, redirect
from backend import app
from backend.forms import LoginForm

# from backend.views.admin import members, orgs


@app.route('/login', methods=['GET', 'POST'])
def login():
    form = LoginForm()
    if form.validate_on_submit():
        flash('Login requested for email="%s", password=%s' %
              (form.email.data, form.password.data))
        return redirect('/index')
    return render_template('login.html',
                           title='Sign In',
                           form=form)


@app.route('/signup', methods=['GET', 'POST'])
def signup():
    form = LoginForm()
    if form.validate_on_submit():
        flash('Login requested for email="%s", password=%s' %
              (form.email.data, form.password.data))
        return redirect('/index')
    return render_template('login.html',
                           title='Sign In',
                           form=form)
