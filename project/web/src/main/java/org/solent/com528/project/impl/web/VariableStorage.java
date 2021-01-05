package org.solent.com528.project.impl.web;


import org.solent.com528.project.model.dao.PriceCalculatorDAO;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *this is a cheap and nasty work around for an issue i am having where
 * priceCalcDAO is null when serviceFacade.getPriceCalculatorDAO
 * @author Jacob
 */
public class VariableStorage {
    
    private static PriceCalculatorDAO storedPriceCalcDAO= null;
    
    public static void setStoredPriceCalcDAO(PriceCalculatorDAO storedPriceCalcDAO)
    {
        VariableStorage.storedPriceCalcDAO = storedPriceCalcDAO;
    }
    public static PriceCalculatorDAO getStoredPriceCalcDAO()
    {
        return VariableStorage.storedPriceCalcDAO;
    }
}
