<%-- 
    Document   : openGate
    Created on : Apr 14, 2020, 12:23:26 PM
    Author     : cgallen
--%>

<%@page import="solent.ac.uk.com504.examples.ticketgate.rest.TicketHandler"%>
<%@page import="java.security.PublicKey"%>
<%@page import="solent.ac.uk.com504.examples.ticketgate.crypto.AsymmetricCryptography"%>
<%@page import="java.io.StringReader"%>
<%@page import="javax.xml.bind.Unmarshaller"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="solent.ac.uk.com504.examples.ticketgate.model.util.DateTimeAdapter"%>
<%@page import="solent.ac.uk.com504.examples.ticketgate.service.GateEntryServiceImpl"%>
<%@page import="solent.ac.uk.com504.examples.ticketgate.service.GateManagementServiceImpl"%>
<%@page import="solent.ac.uk.com504.examples.ticketgate.service.ServiceFactoryImpl"%>
<%@page import="solent.ac.uk.com504.examples.ticketgate.model.service.GateEntryService"%>
<%@page import="solent.ac.uk.com504.examples.ticketgate.model.service.GateManagementService"%>
<%@page import="solent.ac.uk.com504.examples.ticketgate.model.dto.Ticket"%>
<%@page import="javax.xml.bind.JAXBContext"%>
<%@page import="java.io.StringWriter"%>
<%@page import="javax.xml.bind.Marshaller"%>

<%
    String errorMessage = "";

    GateEntryService gateEntryService = ServiceFactoryImpl.getGateEntryService();
    // pull in standard date format
    DateFormat df = new SimpleDateFormat(DateTimeAdapter.DATE_FORMAT);
    
    String currentTimeStr = request.getParameter("currentTime");
    if(currentTimeStr==null || currentTimeStr.isEmpty() ){
        currentTimeStr =  df.format(new Date());
    }
   
    String zonesTravelledStr = request.getParameter("zonesTravelled");
    if (zonesTravelledStr == null || zonesTravelledStr.isEmpty()) {
        zonesTravelledStr = "1";
    }

    String ticketStr = request.getParameter("ticketStr");
    if (ticketStr == null || ticketStr.isEmpty() ) {
        ticketStr = "";
    }
    
    boolean gateOpen = false;
    
    if(ticketStr != ""){
        Ticket ticketFromXml = Ticket.fromXML(ticketStr);
        
        String ecndoedStr = ticketFromXml.getEncodedKey();
        AsymmetricCryptography ac = new AsymmetricCryptography();
        PublicKey publicKey = ac.getPublicFromClassPath("publicKey");
        String decodedTicket = ac.decryptText(ecndoedStr, publicKey);
    
        TicketHandler ticketHandler = new TicketHandler();
        Date validFrom = ticketHandler.GetValidTimeFrom(decodedTicket);
        Date validTo = ticketHandler.GetValidTimeTo(decodedTicket);
        //checks if station and zones match
        boolean match = ticketHandler.TicketsMatch(ticketFromXml, decodedTicket);
        //checks if zones in encoded ticket are qual to or less than zones travelled feild
        boolean zonesOk = ticketHandler.ZonesTravelledOk(zonesTravelledStr, decodedTicket);
                
        
        Date currentTimeDate = df.parse(currentTimeStr);
        //subtracts one second from validFrom Date
        long validFromTime = validFrom.getTime();
        validFromTime = validFromTime - 100;
        validFrom.setTime(validFromTime);
        
        //adds one second from validFrom Date
        long validToTime = validTo.getTime();
        validToTime = validToTime + 100;
        validTo.setTime(validToTime);
        
        if(validFrom.before(currentTimeDate) && validTo.after(currentTimeDate) && match && zonesOk){
            gateOpen = gateEntryService.openGate(ticketFromXml, zonesTravelledStr, currentTimeDate);
            }
    }

    /* *************************************************************************
    //TODO WRITE CODE TO OPEN GATE USING gateEntryService AND DATE FROM THE PAGE
    // hint - look at how the generateTicket.jsp creates tickets and think how 
    // you would reverse the process
    **************************************************************************** */
    

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Open gate</title>
    </head>
    <body>
        <h1>Open Gate with Ticket</h1>
        <!-- print error message if there is one -->
        <div style="color:red;"><%=errorMessage%></div>
        <form action="./openGate.jsp"  method="post" >
            <table>
                <tr>
                    <td>Current Time</td>
                    <td>
                        <input type="text" name="currentTime" value="<%=currentTimeStr%>">
                    </td>
                </tr>
                <tr>
                    <td>Zones Travelled:</td>
                    <td><input type="text" name="zonesTravelled" value="<%=zonesTravelledStr%>"></td>
                </tr>
                <tr>
                    <td>Ticket Data:</td>
                    <td><textarea name="ticketStr" rows="10" cols="120"><%=ticketStr%></textarea></td>
                </tr>
            </table>
            <button type="submit" >Open Gate</button>
        </form> 
        <BR>
        <% if (gateOpen) { %>
        <div style="color:green;font-size:x-large">GATE OPEN</div>
        <%  } else {  %>
        <div style="color:red;font-size:x-large">GATE LOCKED</div>
        <% }%>
    </body>
</html>
