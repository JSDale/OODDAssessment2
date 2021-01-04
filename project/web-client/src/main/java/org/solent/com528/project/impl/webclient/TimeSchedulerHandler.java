/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.solent.com528.project.impl.webclient;

import org.solent.com528.project.impl.webclient.WebClientObjectFactory;
import org.solent.com528.project.model.dao.PriceCalculatorDAO;
import org.solent.com528.project.model.dto.PricingDetails;
import org.solent.com528.project.model.service.ServiceFacade;

/**
 *
 * @author Jacob
 */
public class TimeSchedulerHandler 
{
    public PricingDetails getPriceDetails()
    {
        ServiceFacade clientServiceFacade = (ServiceFacade) WebClientObjectFactory.getServiceFacade();
        PriceCalculatorDAO priceCalcDAO = clientServiceFacade.getPriceCalculatorDAO();
        PricingDetails pd = priceCalcDAO.getPricingDetails();
        pd.toString();
        return pd;
    }
}
