/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Tests;
import java.util.List;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.Test;
import static org.junit.Assert.*;
import org.solent.com528.project.impl.webclient.WebClientObjectFactory;
import org.solent.com528.project.model.dao.PriceCalculatorDAO;
import org.solent.com528.project.model.dto.PriceBand;
import org.solent.com528.project.model.dto.PricingDetails;
import org.solent.com528.project.model.dto.Rate;
import static org.solent.com528.project.model.dto.Rate.OFFPEAK;
import static org.solent.com528.project.model.dto.Rate.PEAK;
import org.solent.com528.project.model.service.ServiceFacade;

/**
 *
 * @author jsdale
 */
public class PriceBandTest {

    final static Logger LOG = LogManager.getLogger(PriceBandTest.class);

    @Test
    //this was used to better my understanding of how to view price bands.
    public void testHowToReadPriceBand()
    {
        ServiceFacade cleintServiceFacade = (ServiceFacade) WebClientObjectFactory.getServiceFacade();
        PriceCalculatorDAO priceCalcDAO = cleintServiceFacade.getPriceCalculatorDAO();
        PricingDetails pd = priceCalcDAO.getPricingDetails();
        List<PriceBand> pdList = pd.getPriceBandList();
        String testStr = pd.toString();
        System.out.println(pdList +"  "+ testStr);
    }
    
    @Test
    //this was used to better my understanding of how to save new price bands.
    public void testWherePriceBandSaved()
    {
        ServiceFacade cleintServiceFacade = (ServiceFacade) WebClientObjectFactory.getServiceFacade();
        PriceCalculatorDAO priceCalcDAO = cleintServiceFacade.getPriceCalculatorDAO();
        PricingDetails pd = priceCalcDAO.getPricingDetails();
        Rate offPeakRate = OFFPEAK;
        Rate peakRate = PEAK;
        PriceBand pb = new PriceBand();
        pb.setHour(15);
        pb.setMinutes(0);
        pb.setRate(peakRate);
        List<PriceBand> pbList = pd.getPriceBandList();
        pbList.add(pb);
        pd.setPriceBandList(pbList);
        priceCalcDAO.savePricingDetails(pd);
    }

}
