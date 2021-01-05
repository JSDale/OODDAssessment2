/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Testing;

import junit.framework.Assert;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.*;
import org.solent.com528.project.impl.web.WebObjectFactory;
import org.solent.com528.project.model.dao.StationDAO;
import org.solent.com528.project.model.dao.TicketMachineDAO;
import org.solent.com528.project.model.dto.Station;
import org.solent.com528.project.model.dto.TicketMachine;
import org.solent.com528.project.model.service.ServiceFacade;

/**
 *
 * @author Jacob
 */
public class testCrudOperationsTicketMachine 
{
    @Test
    public void testDeleteMachineById() 
    {
        ServiceFacade serviceFacade = (ServiceFacade) WebObjectFactory.getServiceFacade();
        StationDAO stationDAO = serviceFacade.getStationDAO();
        Station station = stationDAO.findByName("Abbey Road");
        TicketMachineDAO machineDAO = serviceFacade.getTicketMachineDAO();
        TicketMachine tempMachine = new TicketMachine();
        tempMachine.setId(Long.parseLong("100"));
        tempMachine.setStation(station);
        tempMachine.setUuid("test");
        
        machineDAO.deleteById(Long.parseLong("100"));
        boolean machineExists = true;
        TicketMachine machine = null;
        machine = machineDAO.findById(Long.parseLong("100"));
        if(machine == null)
        {
            machineExists = false;
        }
        assertFalse(machineExists);
    }
}
