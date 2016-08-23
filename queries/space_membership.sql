select m.*
from memberships m
join users u
on m.member_id=u.id
where m.membershipable_type = 'Space'
and u.email NOT SIMILAR TO '%(test|tester|gloowizard|tangogroup|gloo|cru|example|lauderdale|10|doe|tango|singularity-interactive)%'
