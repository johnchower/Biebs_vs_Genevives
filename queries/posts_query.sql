select p.*
from posts p
join users u
on p.user_id=u.id
where user_id is not null 
and owner_type = 'User'
and u.email NOT SIMILAR TO '%(test|tester|gloowizard|tangogroup|gloo|cru|example|lauderdale|10|doe|tango|singularity-interactive)%'
