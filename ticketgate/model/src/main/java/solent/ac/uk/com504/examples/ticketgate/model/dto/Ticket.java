package solent.ac.uk.com504.examples.ticketgate.model.dto;

import java.io.StringReader;
import java.io.StringWriter;
import java.util.Date;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;
import javax.xml.bind.PropertyException;
import javax.xml.bind.Unmarshaller;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;
import solent.ac.uk.com504.examples.ticketgate.model.util.DateTimeAdapter;

@XmlRootElement
@XmlAccessorType(XmlAccessType.FIELD)
public class Ticket {

    private String zones;
    
    private String startStation;

    private String encodedKey;
    
    private int uniqueId;

    // this makes sure we use a common format for marshalling date
    @XmlElement(name = "validFrom")
    @XmlJavaTypeAdapter(DateTimeAdapter.class)
    private Date validFrom;

    @XmlElement(name = "validTo")
    @XmlJavaTypeAdapter(DateTimeAdapter.class)
    private Date validTo;

    /**
     * returns content of ticket without the encoded key
    */
    public String getContent() {
        return "Ticket{" + "zones=" + zones + ", startStation=" + startStation + ", validFrom=" + validFrom + ", validTo=" + validTo + '}';
    }

    public int getUniqueId()
    {
        return uniqueId;
    }
    
    public void setUniqueId(int uniqueId)
    {
         this.uniqueId = uniqueId;
    }
    
    public String getZones() {
        return zones;
    }

    public void setZones(String zones) {
        this.zones = zones;
    }

    public String getEncodedKey() {
        return encodedKey;
    }

    public void setEncodedKey(String encodedKey) {
        this.encodedKey = encodedKey;
    }

    public Date getValidFrom() {
        return validFrom;
    }

    public void setValidFrom(Date validFrom) {
        this.validFrom = validFrom;
    }

    public Date getValidTo() {
        return validTo;
    }

    public void setValidTo(Date validTo) {
        this.validTo = validTo;
    }

    public String getStartStation() {
        return startStation;
    }

    public void setStartStation(String startStation) {
        this.startStation = startStation;
    }

    @Override
    public String toString() {
        return "Ticket{" + "zones=" + zones + ", startStation=" + startStation + ", encodedKey=" + encodedKey + ", validFrom=" + validFrom + ", validTo=" + validTo + '}';
    }

    // un serialise ticket as xml 
    public static Ticket fromXML(String ticketXML) {
        try {
            //  but allows for refactoring
            JAXBContext jaxbContext = JAXBContext.newInstance("solent.ac.uk.com504.examples.ticketgate.model.dto");
            Unmarshaller jaxbUnMarshaller = jaxbContext.createUnmarshaller();
            Ticket ticket = (Ticket) jaxbUnMarshaller.unmarshal(new StringReader(ticketXML));
            return ticket;
        } catch (Exception ex) {
            throw new IllegalArgumentException("could not marshall to Ticket ticketXML=" + ticketXML);
        }
    }

    /**
     * serialise ticket as xml 
    */
    public String toXML() {

        try {
            JAXBContext jaxbContext = JAXBContext.newInstance("solent.ac.uk.com504.examples.ticketgate.model.dto");
            Marshaller jaxbMarshaller = jaxbContext.createMarshaller();
            // output pretty printed
            jaxbMarshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
            StringWriter sw1 = new StringWriter();
            jaxbMarshaller.marshal(this, sw1);
            return sw1.toString();
        } catch (Exception ex) {
            throw new RuntimeException("problem marshalling ticket", ex);
        }
    }

}
