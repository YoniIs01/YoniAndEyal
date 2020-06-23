select m.RockType, 
	   m.NumGrains,
	   TRUNCATE(s.stepid,-2), 
       count(*)
       
from steps as s
join chunkevents as c 
	on (s.stepid = c.stepid and s.modelid = c.modelid)
join models as m 
	on (m._id = s.modelid)
where c.Area > 50
group by s.modelid,m.NumGrains, TRUNCATE(s.stepid,-2)
having count(*) > 40
order by count(*) desc

;

select avg(c.area)
from chunkevents as c
group by modelid
;

select 
	m._id ,tf.TotalDissolution /count(*)
from models as m 
join models_info as mi
on mi.modelid = m._id
join totaldissolutionon500stepsfrombottom as tf
on tf.modelId = m._id
join steps s
	on s.modelid = m._id
    and s.stepId >= mi.SolutionOutOfBBoxStepId - 500 
    and s.stepId <= mi.SolutionOutOfBBoxStepId
group by m._id;



