select 
	m._id,m.Orientation,m.NumGrains ,tf.TotalDissolution /count(*)
from models as m 
join models_info as mi
on mi.modelid = m._id
join totaldissolutiononStabilizedsteps as tf
on tf.modelId = m._id
join steps s
	on s.modelid = m._id
    and s.stepId >= mi.SolutionContactStabilizedStepId
    and s.stepId <= mi.SolutionOutOfBBoxStepId
where m.Orientation != 'None'
group by m._id,m.Orientation,m.NumGrains;

