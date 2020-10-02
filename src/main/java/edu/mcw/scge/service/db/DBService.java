package edu.mcw.scge.service.db;

import edu.mcw.scge.dao.implementation.ExperimentRecordDao;
import edu.mcw.scge.datamodel.ExperimentRecord;

import java.util.List;

public class DBService {
    public List<ExperimentRecord> getAllExperimentRecords() throws Exception {
        ExperimentRecordDao edao=new ExperimentRecordDao();
      return   edao.getExperimentRecords();
    }
    public List<ExperimentRecord> getAllExperimentRecordsByLabId(int labId) throws Exception {
        ExperimentRecordDao edao=new ExperimentRecordDao();
       return   edao.getExperimentRecordsByLabId(labId);
      //  return   edao.getExperimentRecords();
    }
}
