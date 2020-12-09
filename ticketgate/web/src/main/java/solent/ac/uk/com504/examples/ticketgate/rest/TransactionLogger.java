/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package solent.ac.uk.com504.examples.ticketgate.rest;

import java.util.logging.Level;
import java.util.logging.Logger;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.PropertyException;
import javax.xml.bind.Unmarshaller;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

/**
 *
 * @author Jacob
 */
public class TransactionLogger 
{
    public void toXml()
    {
        try 
        {
            JAXBContext jaxbContext = JAXBContext.newInstance("solent.ac.uk.com504.examples.ticketgate.model.dto");
        } 
        catch (JAXBException ex) 
        {
            throw new RuntimeException(ex.getCause());
        }
    }
}
