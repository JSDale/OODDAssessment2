/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package solent.ac.uk.com504.examples.ticketgate.rest;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import static org.apache.commons.io.FilenameUtils.getPath;
import solent.ac.uk.com504.examples.ticketgate.model.dto.Ticket;
import solent.ac.uk.com504.examples.ticketgate.model.util.DateTimeAdapter;

/**
 *
 * @author Jacob Dale
 */
public class TicketHandler {
    
    public Date GetValidTimeFrom(String decodedTicket)
    {
        Ticket tempTicket = GetTicketFromString(decodedTicket);
        return tempTicket.getValidFrom();
    }
    
    public Date GetValidTimeTo(String decodedTicket)
    {
        Ticket tempTicket = GetTicketFromString(decodedTicket);
        return tempTicket.getValidTo();
    }
    
    public boolean TicketsMatch(Ticket ticketFromXml, String decodedTicket)
    {
        Ticket tempTicket = GetTicketFromString(decodedTicket);
        boolean match = false;
        if(ticketFromXml.getStartStation().equals(tempTicket.getStartStation()))
        {
            match = true;
        }
        if(ticketFromXml.getStartStation().equals(tempTicket.getStartStation()))
        {
            match = true;
        }
        if(ticketFromXml.getValidFrom() == tempTicket.getValidFrom())
        {
             match = true;
        }
        if(ticketFromXml.getValidTo() == tempTicket.getValidTo())
        {
             match = true;
        }        
        
        return match;
    }
    
    public boolean ZonesTravelledOk(String zonesTravelled, String decodedTicket)
    {
        boolean zonesTravelledOk = false;
        Ticket tempTicket = GetTicketFromString(decodedTicket);
        String  tempTicketZonesStr = tempTicket.getZones();
        int tempTicketZones = Integer.parseInt(tempTicketZonesStr);
        int ticketFromFeild = Integer.parseInt(zonesTravelled);
        
        if(tempTicketZones >= ticketFromFeild)
        {
            zonesTravelledOk = true;
        }
            
        return zonesTravelledOk;
    }
    
    private Ticket GetTicketFromString(String decodedTicket)
    {
        String[] tempArr= decodedTicket.split(","); 
        DateFormat dateFormat = new SimpleDateFormat("EEE MMM dd HH:mm:ss ZZZ yyyy");
        DateFormat df = new SimpleDateFormat(DateTimeAdapter.DATE_FORMAT);
        Date validFrom = new Date();
        Date validTo = new Date();
        Ticket tempTicket = new Ticket();
        
        for(int i = 0; i < tempArr.length; i++)
        {
            if(tempArr[i].contains("validTo"))
            {
                String tempStr = tempArr[i].replace(" validTo=", "");
                tempStr = tempStr.replace("}", "");
                try{
                     validTo = dateFormat.parse(tempStr);
                     tempTicket.setValidTo(validTo);
                }
               catch(Exception ex)
               {
                    throw new RuntimeException(ex.getMessage());
               }
            }
                
                if(tempArr[i].contains("validFrom"))
                {
                    String tempStr = tempArr[i].replace(" validFrom=", "");
                    try{
                         validFrom = dateFormat.parse(tempStr);
                         tempTicket.setValidFrom(validFrom);
                    }
                   catch(Exception ex)
                   {
                        throw new RuntimeException(ex.getMessage());
                   }
                }
                if(tempArr[i].contains("startStation"))
                {
                    String startStation = tempArr[i].replace(" startStation=", "");
                    tempTicket.setStartStation(startStation);
                }
                if(tempArr[i].contains("zones"))
                {
                    String zones = tempArr[i].replace("Ticket{zones=", "");
                    tempTicket.setZones(zones);
                }
            }
         return tempTicket;
    }
    
    public int generateUniquId() throws IOException
    {
        String fileNameStr = getPath("LastUsedId.txt");
        Path fileName = Path.of(fileNameStr);
        
        if(Files.exists(fileName))
        {
            String latestId = null;
            try 
            {
                latestId = Files.readString(fileName);
            } 
            catch (IOException ex) 
            {
                Files.writeString(fileName, "1024");
                return 1024;
            }
            if(latestId != null)
            {
                int latestIdInt = Integer.parseInt(latestId);
            
                int newId = latestIdInt + 1;
                Files.writeString(fileName, latestId);
                return newId;
            }
        }
        
        throw new RuntimeException("File doesn't exsist");
    }
}
