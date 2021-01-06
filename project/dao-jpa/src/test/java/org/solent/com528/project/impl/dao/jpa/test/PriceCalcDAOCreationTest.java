/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.solent.com528.project.impl.dao.jpa.test;

import org.junit.Test;
import static org.junit.Assert.*;
import org.solent.com528.project.impl.dao.jpa.DAOFactoryJPAImpl;
import org.solent.com528.project.model.dao.DAOFactory;
import org.solent.com528.project.model.dao.PriceCalculatorDAO;
import org.solent.com528.project.model.service.ServiceFacade;
import org.solent.com528.project.model.web.WebObjectFactory;

/**
 *
 * @author Jacob
 */
public class PriceCalcDAOCreationTest {
    
    @Test
    //this tests that the priceCalculatorDAO is not null when called
    public void testPriceDAOCreation()
    {
        DAOFactory daoFactory = new DAOFactoryJPAImpl();
        PriceCalculatorDAO priceCalculatorDAO = daoFactory.getPriceCalculatorDAO();
        assertNotNull(priceCalculatorDAO);
    }
      
}
