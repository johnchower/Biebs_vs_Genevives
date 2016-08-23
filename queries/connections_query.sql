select c.* 
from connections c
join users u1
on u1.id=c.connectable1_id
join users u2
on u2.id=c.connectable2_id
where c.connectable1_type = 'User' 
and c.connectable2_type = 'User'
and u1.email NOT SIMILAR TO '%(test|tester|gloowizard|tangogroup|gloo|cru|example|lauderdale|10|doe|tango|singularity-interactive)%'
and u2.email NOT SIMILAR TO '%(test|tester|gloowizard|tangogroup|gloo|cru|example|lauderdale|10|doe|tango|singularity-interactive)%'
