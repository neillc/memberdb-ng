import json
from backend import app
from backend.models import Members

app.api_manager.create_api(
    Members, 
    methods=['GET', 'POST', 'PATCH', 'DELETE'], 
    collection_name='members'
)


#@app.route('/members')
#def index():
    #members = []
    #for member in app.session.query(app.Members).all():
        #if member.date_entered:
            #date_entered = member.date_entered.strftime('%Y-%m-%d %H:%M:%s') 
        #else:
            #date_entered = None

        #members.append({
            #'id':member.id,
            #'date_entered':date_entered,
            #'first_name':member.first_name, 'middle_name':member.middle_name,
            #'last_name':member.last_name,
            #'DOB':member.DOB.strftime('%Y-%m-%d HH:mm:ss') if member.DOB else
#None, 'sex':member.sex,
            #'address1':member.address1, 'address2':member.address2,
            #'suburb':member.suburb, 'postcode':member.postcode,
            #'state':member.state, 'country':member.country,
            #'email':member.email, 'phone_home':member.phone_home,
            #'phone_mobile':member.phone_mobile
        #})
    #return json.dumps(members)

