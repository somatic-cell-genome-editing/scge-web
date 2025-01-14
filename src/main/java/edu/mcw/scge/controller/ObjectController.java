package edu.mcw.scge.controller;

import edu.mcw.scge.dao.implementation.ExperimentDao;
import edu.mcw.scge.dao.implementation.StudyDao;
import edu.mcw.scge.datamodel.Experiment;
import edu.mcw.scge.datamodel.ExperimentRecord;
import edu.mcw.scge.datamodel.Study;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class ObjectController  {
    ExperimentDao experimentDao=new ExperimentDao();
    StudyDao studyDao=new StudyDao();
    public  void mapProjectNExperiments(List<ExperimentRecord> experimentRecords, HttpServletRequest req) throws Exception {
        Map<Integer, List<Experiment>> studyExperimentsMap=new HashMap<>();
        List<Long> associatedExperimentIds=experimentRecords.stream().map(ExperimentRecord::getExperimentId).distinct().collect(Collectors.toList());
        List<Experiment> assocatedExperiments=new ArrayList<>();

        for(long id:associatedExperimentIds){
            assocatedExperiments.add(experimentDao.getExperiment(id));
        }
        for(Experiment experiment:assocatedExperiments){
            Study study=studyDao.getStudyByStudyId( experiment.getStudyId());
            List<Experiment> experiments=new ArrayList<>();
            if(study!=null) {
                if (studyExperimentsMap.get(study.getGroupId()) != null) {
                    experiments.addAll(studyExperimentsMap.get(study.getGroupId()));
                }
                experiments.add(experiment);
                studyExperimentsMap.put(study.getGroupId(), experiments);
            }
        }
        req.setAttribute("associatedExperiments", assocatedExperiments);
        req.setAttribute("studyExperimentsMap", studyExperimentsMap);
    }
}
