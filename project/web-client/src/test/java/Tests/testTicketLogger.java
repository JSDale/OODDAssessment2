/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Tests;

import static org.junit.Assert.*;
import org.junit.Test;
import org.solent.com528.project.impl.webclient.TicketLogger;

/**
 *
 * @author Jacob
 */
public class testTicketLogger 
{  
    @Test
    public void TestLogging()
    {
        TicketLogger tl = new TicketLogger();
        String encodedTicket = "test";
        tl.LogTicketAsXML(encodedTicket);
    }
}
