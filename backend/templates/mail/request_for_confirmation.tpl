Somebody (most likely you) has submitted this email address
as their email address when applying for Linux Australia
http://www.linux.org.au/membership

On {{ now }} the following data was submitted on our website:
First Name: {{ member.first_name }}
Middle Name/Initial: {{ member.middle_name }}
Surname: {{ member.last_name }}
Sex: {{ member.sex}}
Address 1: {{ member.address1 }}
Address 2: {{ member.address2 }}
Suburb: {{ member.suburb }}
Postcode: {{ member.postcode }}
State: {{ member.state }}
Country: {{ member.country }}
Email: {{ member.email }}
Home Phone: {{ member.phone_home }}
Mobile Phone: {{ member.phone_mobile }}



YOUR APPLICATION IS NOT READY YET!

You must visit this link to confirm that this application
is valid. If you have received this message erroneously,
just ignore it and it will go away.

{{ url_for('confirm_membership', id=member.id, _external=True) }}