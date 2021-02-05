package edu.mcw.scge.configuration;


import edu.mcw.scge.datamodel.PersonInfo;
import edu.mcw.scge.datamodel.Study;

import java.util.List;

public class Access {


    private static Access a;

    public static Access getInstance() {
        if (a == null) {
            return a;
        }else {
            return new Access();
        }

    }

    public boolean hasAccessToStudy(PersonInfo p, Study s) {
        if(s.getGroupId()==p.getSubGroupId()){
                return true;
        }
        return false;
    }

    public boolean hasAccessToStudy(List<PersonInfo> pList, Study s) {
        for (PersonInfo p: pList) {
            return hasAccessToStudy(p,s);
        }
        return false;
    }

    public boolean hasAccessToExperiment() {
        return false;
    }

}
