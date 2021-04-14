package edu.mcw.scge.service.db;

import edu.mcw.scge.dao.implementation.*;
import edu.mcw.scge.datamodel.*;

import java.util.List;

public class DBService {

   /* public List<ExperimentRecord> getAllExperimentRecords() throws Exception {
        ExperimentRecordDao edao=new ExperimentRecordDao();
      return   edao.getExperimentRecords();
    }
    */
   /* public List<ExperimentRecord> getAllExperimentRecordsByLabId(int labId) throws Exception {
        ExperimentRecordDao edao=new ExperimentRecordDao();
       return   edao.getExperimentRecordsByLabId(labId);
      //  return   edao.getExperimentRecords();
    }
    */
   /* public List<ExperimentRecord> getAllExperimentRecordsByStudyId(int studyId) throws Exception {
        ExperimentRecordDao edao=new ExperimentRecordDao();
        return   edao.getExperimentRecordsByStudyId(studyId);
        //  return   edao.getExperimentRecords();
    } */
    public List<Experiment> getAllExperimentsByStudyId(int studyId) throws Exception {
        ExperimentDao edao=new ExperimentDao();
        return   edao.getExperimentsByStudy(studyId);
        //  return   edao.getExperimentRecords();
    }
    /*public List<ExperimentRecord> getExperimentRecordById(int expId) throws Exception {
        ExperimentRecordDao edao=new ExperimentRecordDao();
        return   edao.getExperimentRecordById(expId);
        //  return   edao.getExperimentRecords();
    }*/
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
    public List<Editor> getEditors(int editorId) throws Exception {
        EditorDao dao = new EditorDao();
        return dao.getEditorById(editorId);
    }
    public List<Guide> getGuides(int guideId) throws Exception {
        GuideDao dao = new GuideDao();
        return dao.getGuideById(guideId);
    }
    public List<Guide> getGuidesByExpRecId(int expRecId) throws Exception {
        GuideDao dao = new GuideDao();
        return dao.getGuidesByExpRecId(expRecId);
    }
    public List<Vector> getVectors(int vectorId) throws Exception {
        VectorDao dao = new VectorDao();
        return dao.getVectorById(vectorId);
    }
    public List<ApplicationMethod> getApplicationMethodsById(int applicationMethodId) throws Exception {
        ApplicationMethodDao dao=new ApplicationMethodDao();
        return dao.getApplicationMethod(applicationMethodId);
    }
    public List<Sample> getSampleDetails(int resultId, int experimentRecId) throws Exception {
        AnimalTestingResultsDAO dao=new AnimalTestingResultsDAO();
        return dao.getSampleDetailsByResultId(resultId,experimentRecId);
    }

    public List<ExperimentResultDetail> getExperimentalResults(int expRecId) throws Exception{
        ExperimentResultDao dao = new ExperimentResultDao();
        return dao.getResultsByExperimentRecId(expRecId);
    }
    public List<Study> getStudiesByGroupId(int groupId){

        return null;
    }
}
