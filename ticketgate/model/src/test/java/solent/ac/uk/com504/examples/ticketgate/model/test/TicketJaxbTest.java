/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package solent.ac.uk.com504.examples.ticketgate.model.test;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.security.MessageDigest;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import org.junit.Assert;
import org.junit.Test;
import solent.ac.uk.com504.examples.ticketgate.model.dto.Ticket;
import static org.junit.Assert.*;
import org.junit.Test;
import solent.ac.uk.com504.examples.ticketgate.model.util.DateTimeAdapter;

/**
 * TEST THAT ticket.toXML and ticket.fromXML both work
 * 
 * create and populate a ticket using new ticket()
 * convert the ticket to an xml string
 * convert the xml string back to a new  ticket
 * check that the data in the two tickets are the same
 * 
 * @author cgallen
 */
public class TicketJaxbTest {

     /**
     * Test that a ticket can be marshalled and un-marshalled to xml using Ticket.toXML() and Ticket.fromXML methods
     */
    @Test
    public void testTicketToXML() {
         //TODO ADD TEST CODE HERE
         Ticket actualTicket = new Ticket();
         actualTicket.setZones("1");
         actualTicket.setStartStation("Luton");
         DateFormat df = new SimpleDateFormat(DateTimeAdapter.DATE_FORMAT);
         
         try{
           Date  validFrom = df.parse("02-12-2020 10:15:01");
           actualTicket.setValidFrom(validFrom);
           Date validTo = df.parse("03-12-2020 10:15:01");
           actualTicket.setValidTo(validTo);
         }
         catch(Exception ex)
         {
              throw new RuntimeException(ex.getMessage());
         }
         actualTicket.setEncodedKey("HPYxLpS23SSkSj1ux0DNhTgCO883/0scVFxQ3V/SYPSrQfCQC71JJoGK0Q8WgIRyKvmqzTaJ6rxxQGtPru6SKJhALAxed7SbcFF5hk4qCZq3KK4DESGlLd2pJfeXeAlUJzH2v7yI9pBNGv+FQ2IhQpn9oXr71tiKa8MtpQ5k1ds=");
         
         String actualTicketXml = actualTicket.toXML();
         
         String expectedTicket =  "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n" +
                                                "<ticket>\n" +
                                                "    <zones>1</zones>\n" +
                                                "    <startStation>Luton</startStation>\n" +
                                                "    <encodedKey>HPYxLpS23SSkSj1ux0DNhTgCO883/0scVFxQ3V/SYPSrQfCQC71JJoGK0Q8WgIRyKvmqzTaJ6rxxQGtPru6SKJhALAxed7SbcFF5hk4qCZq3KK4DESGlLd2pJfeXeAlUJzH2v7yI9pBNGv+FQ2IhQpn9oXr71tiKa8MtpQ5k1ds=</encodedKey>\n" +
                                                "    <validFrom>02-12-2020 10:15:01</validFrom>\n" +
                                                "    <validTo>03-12-2020 10:15:01</validTo>\n" +
                                                "</ticket>";
         /*
         logs a file to see if the strings were identical
            try
            {
                String fileName = "D:\\log.txt";
                BufferedWriter writer = new BufferedWriter(new FileWriter(fileName));
                writer.write(expectedTicket);
                writer.write("\n\n\n\n actual \n\n\n\n");
                 writer.write(actualTicketXml);
                writer.close();   
            }
            catch(Exception ex)
            {
                         throw new RuntimeException(ex.getMessage());
           }
*/ 
            
    
            System.out.print( actualTicketXml);
            System.out.print( expectedTicket);
           
           char[] test2 = new char[actualTicketXml.length()];
           char[] test3 = new char[expectedTicket.length()];
           
           for (int i = 0; i < actualTicketXml.length(); i++) { 
            test2[i] = actualTicketXml.charAt(i);
            //System.out.print(i + ":");
            //System.out.println(test2[i]);
        } 
           for (int i = 0; i < expectedTicket.length(); i++) { 
            test3[i] = expectedTicket.charAt(i);
            //System.out.print(i + ":");
            //System.out.println(test3[i]);
        }
           
           boolean pass = true;
           
           for(int i = 0; i < test3.length; i++)
           {
               if(test3[i] != test2[i])
               {
                  pass = false;
               }
           }
          
            //String expected = actualTicketXml;
            Assert.assertTrue("actual isnt same as expected", pass);
            
            //Both Assert.assertEquals(expected, actual) and expected.equals(actual) failed eventhough the string looked identical.
    }
    
    @Test 
    public void testGetTicketFromXml(){
        String actual = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n" +
                                                "<ticket>\n" +
                                                "    <zones>1</zones>\n" +
                                                "    <startStation>Luton</startStation>\n" +
                                                "    <encodedKey>HPYxLpS23SSkSj1ux0DNhTgCO883/0scVFxQ3V/SYPSrQfCQC71JJoGK0Q8WgIRyKvmqzTaJ6rxxQGtPru6SKJhALAxed7SbcFF5hk4qCZq3KK4DESGlLd2pJfeXeAlUJzH2v7yI9pBNGv+FQ2IhQpn9oXr71tiKa8MtpQ5k1ds=</encodedKey>\n" +
                                                "    <validFrom>02-12-2020 10:15:01</validFrom>\n" +
                                                "    <validTo>03-12-2020 10:15:01</validTo>\n" +
                                                "</ticket>";
         
         Ticket gatheredTicket = Ticket.fromXML(actual);
        
         Ticket createdTicket = new Ticket();
         createdTicket.setZones("1");
         createdTicket.setStartStation("Luton");
         DateFormat df = new SimpleDateFormat(DateTimeAdapter.DATE_FORMAT);
         
         try{
           Date  validFrom = df.parse("02-12-2020 10:15:01");
           createdTicket.setValidFrom(validFrom);
           Date validTo = df.parse("03-12-2020 10:15:01");
           createdTicket.setValidTo(validTo);
         }
         catch(Exception ex)
         {
              throw new RuntimeException(ex.getMessage());
         }
         
         createdTicket.setEncodedKey("HPYxLpS23SSkSj1ux0DNhTgCO883/0scVFxQ3V/SYPSrQfCQC71JJoGK0Q8WgIRyKvmqzTaJ6rxxQGtPru6SKJhALAxed7SbcFF5hk4qCZq3KK4DESGlLd2pJfeXeAlUJzH2v7yI9pBNGv+FQ2IhQpn9oXr71tiKa8MtpQ5k1ds=");
         
         Assert.assertEquals(createdTicket.getContent(), gatheredTicket.getContent());
         
    }

}
