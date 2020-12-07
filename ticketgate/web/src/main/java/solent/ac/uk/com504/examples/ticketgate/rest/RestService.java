/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package solent.ac.uk.com504.examples.ticketgate.rest;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import javax.annotation.Resource;
import javax.ws.rs.Consumes;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import solent.ac.uk.com504.examples.ticketgate.model.dto.Ticket;
import solent.ac.uk.com504.examples.ticketgate.model.dto.ReplyMessage;
import solent.ac.uk.com504.examples.ticketgate.model.util.DateTimeAdapter;

import solent.ac.uk.com504.examples.ticketgate.service.ServiceFactoryImpl;
import solent.ac.uk.com504.examples.ticketgate.model.service.GateManagementService;
import solent.ac.uk.com504.examples.ticketgate.model.service.GateEntryService;

/**
 * To make the ReST interface easier to program. All of the replies are contained in ReplyMessage classes 
 * but only the fields indicated are populated with each reply.
 * All replies will contain a code and a debug message.
 */
@Path("/gatelock")
public class RestService {

    // SETS UP LOGGING 
    // note that log name will be org.solent.com504.factoryandfacade.impl.rest.RestService
    final static Logger LOG = LogManager.getLogger(RestService.class);

    GateEntryService gateLockService = ServiceFactoryImpl.getGateEntryService();
    GateManagementService lockManagementService = ServiceFactoryImpl.getGateManagementService();

    /**
     * this is a very simple rest test message which only returns a string
     *
     * http://localhost:8080/ticketgate/rest/gatelock
     *
     * @return String simple message
     */
    @GET
    public String message() {
        LOG.debug("gatelock called");
        return "Hello, rest!";
    }

    /**
     * POST http://localhost:8080/ticketgate/rest/gatelock/openGate/1/
     * this service validates a ticket and checks if it allows a number of zones
     * You must supply a valid ticket for this to work.
     * @param ticket
     * @param zonesTravelled
     * @return 
     */
    @POST
    @Path("/openGate/{zonesTravelled}/")
    @Consumes({MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML})
    @Produces({MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML})
    public Response openGate(Ticket ticket, @PathParam("zonesTravelled") String zonesTravelled) {
        try {
            LOG.debug("/openGate called zonesTravelled=" + zonesTravelled + " ticket=" + ticket);

            ReplyMessage replyMessage = new ReplyMessage();

            Date currentTime = new Date();

            boolean unlocked = gateLockService.openGate(ticket, zonesTravelled, currentTime);
            replyMessage.setUnlocked(unlocked);

            replyMessage.setCode(Response.Status.OK.getStatusCode());

            return Response.status(Response.Status.OK).entity(replyMessage).build();

        } catch (Exception ex) {
            LOG.error("error calling /openGate/ ", ex);
            ReplyMessage replyMessage = new ReplyMessage();
            replyMessage.setCode(Response.Status.INTERNAL_SERVER_ERROR.getStatusCode());
            replyMessage.setDebugMessage("error calling /openGate/ " + ex.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(replyMessage).build();
        }
    }

    /**
     * This service creates a ticket 
     * POST http://localhost:8080/ticketgate/rest/gatelock/createTicket/?zones=1&startStation=Waterloo&validFrom=01-01-2020 00:00:00&validTo=01-01-2021 00:00:00
     * @param zones (integer - number of zones which ticket covers
     * @param validFromStr (dd-MM-yyyy HH:mm:ss
     * @param validToStr   (dd-MM-yyyy HH:mm:ss)
     * @param startStation  (any string sation name)
     * @return return xml encoded ticket
     */
    @POST
    @Path("/createTicket")
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED})
    @Produces({MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML})
    public Response createTicket(@FormParam("zones") String zones,
            @FormParam("validFrom") String validFromStr,
            @FormParam("validTo") String validToStr,
            @FormParam("startStation") String startStation ) {

        try {
            LOG.debug("/createTicket called zones=" + zones + " validFrom=" + validFromStr + " validTo=" + validToStr);
            
            if(zones==null) throw new IllegalArgumentException("zones must not be null");
            if(validFromStr==null) throw new IllegalArgumentException("validFrom must not be null");
            if(validToStr==null) throw new IllegalArgumentException("validTo must not be null");
            if(startStation==null) throw new IllegalArgumentException("startStation must not be null");

            // formats date to format given by constant DateTimeAdapter.DATE_FORMAT (currently dd-MM-yyyy HH:mm:ss)
            SimpleDateFormat df = new SimpleDateFormat(DateTimeAdapter.DATE_FORMAT);
            Date validFrom = df.parse(validFromStr);
            Date validTo = df.parse(validToStr);
            Ticket ticket = lockManagementService.createTicket(zones, validFrom, validTo, startStation);
    
            ReplyMessage replyMessage = new ReplyMessage();
            replyMessage.setTicket(ticket);

            replyMessage.setCode(Response.Status.OK.getStatusCode());

            return Response.status(Response.Status.OK).entity(replyMessage).build();

        } catch (Exception ex) {
            LOG.error("error calling /createTicket ", ex);
            ReplyMessage replyMessage = new ReplyMessage();
            replyMessage.setCode(Response.Status.INTERNAL_SERVER_ERROR.getStatusCode());
            replyMessage.setDebugMessage("error calling /createTicket " + ex.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(replyMessage).build();
        }
    }

}
