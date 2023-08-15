package edu.mcw.scge.storage;

import edu.mcw.scge.dao.implementation.ExperimentDao;
import edu.mcw.scge.dao.implementation.ImageDao;
import edu.mcw.scge.dao.implementation.StudyDao;
import edu.mcw.scge.datamodel.ExperimentRecord;
import edu.mcw.scge.datamodel.Image;
import edu.mcw.scge.web.utils.Stamp;
import org.springframework.http.HttpHeaders;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class ImageCache {

    private HashMap<String, List<Image>> imageMap = new HashMap<String,List<Image>>();
    private HashMap<String, byte[]> imageByteMap = new HashMap<String,byte[]>();

    private static ImageCache ic;

    public static ImageCache getInstance() throws Exception{
        if (ic==null) {
            ic = new ImageCache();
            ic.load();

            return ic;
        }else {
            return ic;
        }
    }

    public byte[] getImageBytes(long experimentRecordId, String bucket, int type) throws Exception{
        if (this.imageByteMap.containsKey(experimentRecordId + "_" + bucket + "_" + type)) {
            Stamp.it("getting from the cache for " + experimentRecordId);
            return this.imageByteMap.get(experimentRecordId + "_" + bucket + "_" + type);

        }else {
            Stamp.it("getting from the database for " + experimentRecordId);
            return new ImageDao().getImageBytes(experimentRecordId,bucket,type);
        }
    }

    public List<Image> getImage(Long id, String bucket) throws Exception{
        if (this.imageMap.containsKey(id + "_" + bucket)) {
            Stamp.it("found in cached for " + id);
            return this.imageMap.get(id + "_" + bucket);
        }else {
            Stamp.it("getting from the DB");
            return new ImageDao().getImage(id,bucket);
        }
    }


    public void load() throws Exception{
        ImageDao idao = new ImageDao();
        ExperimentDao edao = new ExperimentDao();

        //Add experiment ids you would like cached to this list
        ArrayList<Long> experiments= new ArrayList<Long>();
        experiments.add(Long.parseLong("18000000087"));


        for (Long myId: experiments) {
            Stamp.it("loading images for " + myId);

            List<ExperimentRecord> records = edao.getExperimentRecords(myId);

            for (ExperimentRecord record : records) {
                Stamp.it("loading " + record.getExperimentRecordId());
                byte[] media = idao.getImageBytes(record.getExperimentRecordId(), "main1", ImageDao.WIDE_700);
                this.imageByteMap.put(record.getExperimentRecordId() + "_" + "main1" + "_" + ImageDao.WIDE_700, media);
                this.imageMap.put(record.getExperimentRecordId() + "_" + "main1", idao.getImage(record.getExperimentRecordId()));

            }
        }
        Stamp.it("load Complete");
    }

}
