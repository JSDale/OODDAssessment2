/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Testing;


import junit.framework.Assert;
import org.junit.Test;
import static org.junit.Assert.*;
import org.solent.com528.project.impl.web.WebObjectFactory;
import org.solent.com528.project.model.dao.PriceCalculatorDAO;
import org.solent.com528.project.model.service.ServiceFacade;

/**
 *
 * @author Jacob
 */
public class TestScheduler {
    
    //used to see why priceCalcDAO was null()
    @Test
    public void testPriceCalculatorDAO()
    {
        ServiceFacade serviceFacade = (ServiceFacade) WebObjectFactory. getClientServiceFacade();
        PriceCalculatorDAO priceCalcDAO = serviceFacade.getPriceCalculatorDAO();
        double offPeakPrice = priceCalcDAO.getOffpeakPricePerZone();
        System.out.println(offPeakPrice);
        assertTrue(true);
    }
}
