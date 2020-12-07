package solent.ac.uk.com504.examples.ticketgate.model.rest;

import solent.ac.uk.com504.examples.ticketgate.model.dto.Ticket;
import solent.ac.uk.com504.examples.ticketgate.model.dto.ReplyMessage;

public interface RestService {

    public ReplyMessage openGate(Ticket ticket);

    public ReplyMessage createTicket();
    
}
