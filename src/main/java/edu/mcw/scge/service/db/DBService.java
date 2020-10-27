package edu.mcw.scge.service.db;

import edu.mcw.scge.dao.implementation.*;
import edu.mcw.scge.datamodel.*;

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
    public List<ExperimentRecord> getExperimentRecordById(int expId) throws Exception {
        ExperimentRecordDao edao=new ExperimentRecordDao();
        return   edao.getExperimentRecordById(expId);
        //  return   edao.getExperimentRecords();
    }
    public Model getModelById(int modelId) throws Exception {
        ModelDao dao=new ModelDao();
        return dao.getModelById(modelId);
    }
    public List<ReporterElement> getReporterElementsByExpRecId(int experimentRecId) throws Exception{
        RepoterELementDao dao=new RepoterELementDao();
        return dao.getReporterElements(experimentRecId);
    }
    public List<AnimalTestingResultsSummary> getAnimalTestingResultsByExpRecId(int experimentRecordId) throws Exception{
        AnimalTestingResultsDAO dao=new AnimalTestingResultsDAO();
        return dao.getResultsByExperimentRecId(experimentRecordId);
    }
    public List<Delivery> getDeliveryVehicles(int deliveryId) throws Exception {
        DeliveryDao dao=new DeliveryDao();
        return dao.getDeliverySystemsById(deliveryId);
    }
    public List<ApplicationMethod> getApplicationMethodsById(int applicationMethodId) throws Exception {
        ApplicationMethodDao dao=new ApplicationMethodDao();
        return dao.getApplicationMethod(applicationMethodId);
    }
    public List<Sample> getSampleDetails(int resultId, int experimentRecId) throws Exception {
        AnimalTestingResultsDAO dao=new AnimalTestingResultsDAO();
        return dao.getSampleDetailsByResultId(resultId,experimentRecId);
    }
}
