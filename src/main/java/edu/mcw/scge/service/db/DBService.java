package edu.mcw.scge.service.db;

import edu.mcw.scge.dao.implementation.*;
import edu.mcw.scge.datamodel.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
    public Model getModelById(long modelId) throws Exception {
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
    public List<Delivery> getDeliveryVehicles(long deliveryId) throws Exception {
        DeliveryDao dao=new DeliveryDao();
        return dao.getDeliverySystemsById(deliveryId);
    }
    public List<Editor> getEditors(long editorId) throws Exception {
        EditorDao dao = new EditorDao();
        return dao.getEditorById(editorId);
    }
    public List<Guide> getGuides(long guideId) throws Exception {
        GuideDao dao = new GuideDao();
        return dao.getGuideById(guideId);
    }
    public List<Guide> getGuidesByExpRecId(long expRecId) throws Exception {
        GuideDao dao = new GuideDao();
        return dao.getGuidesByExpRecId(expRecId);
    }
    public List<Vector> getVectors(long vectorId) throws Exception {
        VectorDao dao = new VectorDao();
        return dao.getVectorById(vectorId);
    }
    public List<Vector> getVectorsByExpRecId(long expRecId) throws Exception {
        VectorDao dao = new VectorDao();
        return dao.getVectorsByExpRecId(expRecId);
    }
    public List<ApplicationMethod> getApplicationMethodsById(int applicationMethodId) throws Exception {
        ApplicationMethodDao dao=new ApplicationMethodDao();
        return dao.getApplicationMethod(applicationMethodId);
    }
    /*public List<Sample> getSampleDetails(int resultId, long experimentRecId) throws Exception {
        AnimalTestingResultsDAO dao=new AnimalTestingResultsDAO();
        return dao.getSampleDetailsByResultId(resultId,experimentRecId);
    }
*/
    public List<ExperimentResultDetail> getExperimentalResults(long expRecId) throws Exception{
        ExperimentResultDao dao = new ExperimentResultDao();
        return dao.getResultsByExperimentRecId(expRecId);
    }

    public List<ExperimentResultDetail> getExpResultsByExpId(long expId) throws Exception{
        ExperimentResultDao dao = new ExperimentResultDao();
        return dao.getResultsByExperimentId(expId);
    }
    public List<ExperimentResultDetail> getExpResultsByResultType(long expRecId,String resultType) throws Exception{
        ExperimentResultDao dao = new ExperimentResultDao();
        return dao.getResultsByExpResType(expRecId,resultType);
    }
    public Map<String, List<String> > getResultTypeNUnits(long expId) throws Exception {
        Map<String, List<String>> resultTypeNUnits=new HashMap<>();
        for(ExperimentResultDetail detail: getExpResultsByExpId(expId)){
            List<String> units=new ArrayList<>();
            if(resultTypeNUnits.get(detail.getResultType())!=null){
                for(String unit:resultTypeNUnits.get(detail.getResultType())){
                    if(!units.contains(unit)){
                        units.add(unit);
                    }
                }
            }
            if(!units.contains(detail.getUnits())){
                units.add(detail.getUnits());
            }

                resultTypeNUnits.put(detail.getResultType(), units);


        }
       return resultTypeNUnits;
    }

    public List<String> getResultTypes(long expId) throws Exception{
        ExperimentResultDao dao = new ExperimentResultDao();
        return dao.getResTypeByExpId(expId);
    }
    public List<Study> getStudiesByGroupId(int groupId){

        return null;
    }
}
