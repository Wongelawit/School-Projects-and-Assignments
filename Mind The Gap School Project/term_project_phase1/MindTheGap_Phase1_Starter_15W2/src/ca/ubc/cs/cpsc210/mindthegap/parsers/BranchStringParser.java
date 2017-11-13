package ca.ubc.cs.cpsc210.mindthegap.parsers;


import ca.ubc.cs.cpsc210.mindthegap.util.LatLon;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

/**
 * Parser for branch strings in TfL line data
 */
public class BranchStringParser {

    /**
     * Parse a branch string obtained from TFL
     *
     * @param branch  branch string
     * @return       list of lat/lon points parsed from branch string
     */
   /* public static List<LatLon> parseBranch(String branch) {
        String newbranch=branch.replaceAll("[[","");
        System.out.println(newbranch);
        newbranch = newbranch.replaceAll("]]", "");
        System.out.println(newbranch);

        return null;   // stub
    }*/
    public static List<LatLon> parseBranch(String branch){

        List<LatLon> latLonList = new ArrayList<LatLon>();
        if(branch.equals("")){
            return latLonList;
        }

        String newbranch=branch.replaceAll("\\[\\[","");
        //System.out.println(newbranch);
        newbranch = newbranch.replaceAll("\\]\\]\\]", "");
       //System.out.println(newbranch);
        //System.out.println("Return Value :" );
        for (String retval: newbranch.split("\\],")){
           // System.out.println(retval);

            LatLon ll = parseLatLon(retval);
            latLonList.add(ll);
        }


        for(LatLon aa: latLonList){

            //System.out.println(aa.getLatitude()+" , " + aa.getLongitude());
        }
        return latLonList;
    }

    private static LatLon parseLatLon(String latLonString) {



        String parsedString = latLonString.replaceAll("\\[","");
       // System.out.println(parsedString);

        String[] strList = parsedString.split("\\,");

        for (String retval: strList ){
         //   System.out.println(retval);
        }

        double lat = Double.parseDouble(strList[0]);
        double lon = Double.parseDouble(strList[1]);

        LatLon ll = new LatLon(lat, lon);


        return ll;
    }
}
