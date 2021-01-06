/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.solent.com528.project.impl.webclient;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.net.URL;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author Jacob
 */
public class TicketLogger {
    
    final static Logger LOG = LogManager.getLogger(TicketLogger.class);
        
    public void LogTicketAsXML(String encodedTicket)
    {
        File logger = getApplicationRootFile();
        createLogger(logger);
        WriteToFile(encodedTicket, logger);
    }
    
    private File getApplicationRootFile()
    {
        URL url = TicketLogger.class.getResource(".");
        String path = url.getPath();
        String[] pathArr = path.split("client/");
        path = pathArr[0];
        path = path + "client/Logger/";
        File file = new File(path + "TicketLogger.txt");
        return file;
    }
    
    private void createLogger(File logger)
    {
        try
        {
            if(logger.createNewFile())
            {
                LOG.debug("file created: " + logger.getName());
            }
            else
            {
                LOG.debug("file already exsists: " + logger.getName());
            }
        }
        catch(Exception ex)
        {
            LOG.error("couldn't create Ticket Logger");
            LOG.error(ex.getMessage());
        }
    }
    
    private void WriteToFile(String encodedTicket, File logger)
    {
        try
        {
            FileWriter fileWriter = new FileWriter(logger, true);
            fileWriter.append("\n\n\n" + getCurrentTime() +"\n" + encodedTicket);
            //fileWriter.write("\n\n\n" + getCurrentTime() +"\n" + encodedTicket);
            fileWriter.close();
        }
        catch(Exception ex)
        {
            LOG.error("couldn't write to Ticket Logger");
            LOG.error(ex.getMessage());
        }
    }
    
    private String getCurrentTime()
    {
        SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd 'at' HH:mm:ss z");
        Date date = new Date(System.currentTimeMillis());
        String currentDate = formatter.format(date);
        return currentDate;
    }
    
}
