package edu.mcw.scge.web.utils;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;
import java.util.TreeMap;

public interface Crumb {
   public TreeMap<Integer, Map<String, String>> getCrumbTrailMap(HttpServletRequest req,Object parent, Object child,String pageContext );
}
