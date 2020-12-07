package solent.ac.uk.com504.examples.ticketgate.model.service;

import java.util.Date;
import solent.ac.uk.com504.examples.ticketgate.model.dto.Ticket;

public interface GateEntryService {

    public boolean openGate(Ticket ticket, String zonesTravelled, Date currentTime);
    
}
