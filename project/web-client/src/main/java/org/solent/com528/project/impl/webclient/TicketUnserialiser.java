/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.solent.com528.project.impl.webclient;

import java.io.StringReader;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.swing.text.DateFormatter;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Unmarshaller;
import org.solent.com528.project.model.dto.Ticket;

/**
 *
 * @author Jacob
 */
public class TicketUnserialiser {
     
    public Date getIssueDate(String ticketXML) {
        try {
                String[] ticketArray = ticketXML.split("<issueDate>");
                ticketArray = ticketArray[1].split("</issueDate>");
                String validFromStr = ticketArray[0];
                validFromStr = validFromStr.replace(" ", "");
                validFromStr = validFromStr.replace("Z", "");
                Date validFrom = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").parse(validFromStr);
                return validFrom;
                
        } catch (Exception ex) {
            throw new IllegalArgumentException("could not get date from Ticket");
        }
    }
    
     public int getZonesAllowed(String ticketXML) {
        try {
                String[] ticketArray = ticketXML.split("<numberOfZones>");
                ticketArray = ticketArray[1].split("</numberOfZones>");
                String zonesAllowedStr = ticketArray[0];
                int zonesAllowed = Integer.parseInt(zonesAllowedStr);
                return zonesAllowed;
                
        } catch (Exception ex) {
            throw new IllegalArgumentException("could not get zone from Ticket");
        }
    }

}
