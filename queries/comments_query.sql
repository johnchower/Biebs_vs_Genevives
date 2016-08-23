select c.* 
from comments c
join users u
on c.user_id=u.id
where c.owner_type = 'User'
and u.email NOT SIMILAR TO '%(test|tester|gloowizard|tangogroup|gloo|cru|example|lauderdale|10|doe|tango|singularity-interactive)%'
