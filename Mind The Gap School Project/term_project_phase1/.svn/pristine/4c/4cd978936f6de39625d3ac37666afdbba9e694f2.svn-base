package ca.ubc.cs.cpsc210.mindthegap.tests.parsers;

import ca.ubc.cs.cpsc210.mindthegap.TfL.DataProvider;
import ca.ubc.cs.cpsc210.mindthegap.TfL.FileDataProvider;
import ca.ubc.cs.cpsc210.mindthegap.parsers.BranchStringParser;
import ca.ubc.cs.cpsc210.mindthegap.parsers.TfLLineParser;
import ca.ubc.cs.cpsc210.mindthegap.parsers.exception.TfLLineDataMissingException;
import ca.ubc.cs.cpsc210.mindthegap.util.LatLon;
import static org.junit.Assert.*;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

import java.util.List;

import static ca.ubc.cs.cpsc210.mindthegap.parsers.BranchStringParser.*;
import static org.junit.Assert.assertEquals;


/**
 * Unit test for BranchStringParser
 */
public class BranchStringParserTest {
    @Before
    public void setUp() throws Exception {
        DataProvider dataProvider = new FileDataProvider("./res/raw/central_inbound.json");
    }

    @Test
    public void stringTest() {
        String str = "[[[1,2],[3,4]]]";
        //parseBranch(str);
        //String[] expected = {"[1,2],[3,4]"};

        List<LatLon> llList = BranchStringParser.parseBranch(str);

            assertEquals(1, llList.get(0).getLatitude(), 0);
            assertEquals(2, llList.get(0).getLongitude(), 0);
            assertEquals(3, llList.get(1).getLatitude(),0);
            assertEquals(4, llList.get(1).getLongitude(), 0);
    }



}

