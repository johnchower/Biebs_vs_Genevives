select f.*
from follows f 
join users u1
on u1.id=f.follower_id
join users u2
on u2.id=f.followable_id
where followable_type = 'User'
and u1.email NOT SIMILAR TO '%(test|tester|gloowizard|tangogroup|gloo|cru|example|lauderdale|10|doe|tango|singularity-interactive)%'
and u2.email NOT SIMILAR TO '%(test|tester|gloowizard|tangogroup|gloo|cru|example|lauderdale|10|doe|tango|singularity-interactive)%'
