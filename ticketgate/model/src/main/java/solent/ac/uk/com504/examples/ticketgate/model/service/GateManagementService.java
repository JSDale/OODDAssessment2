package solent.ac.uk.com504.examples.ticketgate.model.service;

import java.util.Date;
import solent.ac.uk.com504.examples.ticketgate.model.dto.Ticket;

public interface GateManagementService {
    
    public Ticket createTicket(String zonesStr, Date validFrom, Date validTo, String startStationStr);

}
