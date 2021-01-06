<%-- 
    Document   : openGate
    Created on : 28 Dec 2020, 10:32:50
    Author     : Jacob
--%>

<%@page import="org.solent.com528.project.impl.webclient.DateTimeAdapter"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.solent.com528.project.model.dao.StationDAO"%>
<%@page import="org.solent.com528.project.model.dto.Station"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.solent.com528.project.model.dto.TicketMachineConfig"%>
<%@page import="org.solent.com528.project.model.service.ServiceFacade"%>
<%@page import="org.solent.com528.project.impl.webclient.WebClientObjectFactory"%>
<%@page import="java.util.Date"%>
<%@page import="org.solent.com528.project.model.dto.Ticket"%>
<%@page import="org.solent.com528.project.impl.webclient.TicketUnserialiser"%>
<%@page import="org.solent.com528.project.clientservice.impl.TicketEncoderImpl"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
String errorMessage = "";
boolean isValid = false;
ServiceFacade serviceFacade = (ServiceFacade) WebClientObjectFactory.getServiceFacade();
TicketMachineConfig ticketMachineConf = serviceFacade.getTicketMachineConfig(WebClientObjectFactory.getTicketMachineUuid());
StationDAO stationDAO = serviceFacade.getStationDAO();
List<Station> stationList = new ArrayList();
try
    {
        stationList = ticketMachineConf.getStationList();
    }
    catch(Exception ex)
    {
        errorMessage = "Ticket machine UUID is invalid";
    }
    
    String arrivalStationStr = request.getParameter("arrivalStation");
    if(arrivalStationStr == null || arrivalStationStr.isEmpty()){
        arrivalStationStr = "";
    }   

String ticketStr = request.getParameter("ticketTextArea");
    if (ticketStr == null || ticketStr.isEmpty()) {
        ticketStr = "";
    }

if(ticketStr != "")
{
     boolean encodeIsValid = TicketEncoderImpl.validateTicket(ticketStr);
    try {
            TicketUnserialiser ticketUnserialiser = new TicketUnserialiser();
            Date validFrom = ticketUnserialiser.getIssueDate(ticketStr);
            int zonesAllowed = ticketUnserialiser.getZonesAllowed(ticketStr);
            Station arrivalStation = stationDAO.findByName(arrivalStationStr);
            String departureStationName = ticketMachineConf.getStationName();
            Station departureStation = stationDAO.findByName(departureStationName);
            
            int departZone = departureStation.getZone();
            int arrivalZone = arrivalStation.getZone();
            int zonesTravelled = -1;
             if(departZone > arrivalZone)
                {
                     zonesTravelled = departZone - arrivalZone;
                }
                else if(departZone < arrivalZone)
                {
                      zonesTravelled = arrivalZone - departZone;
                }
                if(zonesTravelled == 0){ zonesTravelled = 1; }
            
            boolean zonesTravelledOk = false;
            if(zonesTravelled <= zonesAllowed){
                zonesTravelledOk = true;
            }
            
            SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd 'at' HH:mm:ss z");
            Date currentDateTime = new Date(System.currentTimeMillis());
            DateFormat df = new SimpleDateFormat(DateTimeAdapter.DATE_FORMAT);
            String validToStr = df.format(new Date(validFrom.getTime() + 1000 * 60 * 60 * 24));
            Date allowedDate = new SimpleDateFormat("dd/MM/yyyy").parse(validToStr); 
            boolean dateAllowed = false;
            if(currentDateTime.before(allowedDate)){
                dateAllowed = true;
            }
            
            if (encodeIsValid && zonesTravelledOk && dateAllowed) {
                isValid = true;
            }
            
        } catch (Exception ex) {
            errorMessage = ex.getLocalizedMessage();
        }
    
}
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage Gate Locks</title>
    </head>
    <body>
        <div style="color:red;"><%=errorMessage%></div>
        <h1>Open Gate</h1>
        <form action="./openGate.jsp"  method="post">
            <table>
                <tr>
                    <td>End Station:</td>
                    <td>
                         <select name="arrivalStation" id="cboEndStation" onchnage="submit">
                             <option value="UNDEFINED">--Select--</option>
                             <%
                                for (Station station : stationList) {
                            %>
                           <option value="<%=station.getName()%>"><%=station.getName()%></option>
                            <%
                                }
                            %>
                            <option value="UNDEFINED">--Select--</option>
                        </select>
                    </td>
                </tr>
                <tr>Enter Ticket:</tr>
                <tr>
                    <td><textarea name="ticketTextArea" id="ticketTextArea" rows="15" cols="150" ><%=ticketStr%></textarea></td>
                </tr>
            </table>
            <button type="submit" >Open Gate</button>
        </form>
        <% if (isValid) { %>
        <div style="color:green;font-size:64px">GATE OPEN</div>
        <%  } else {  %>
        <div style="color:red; font-size:64px">GATE LOCKED</div>
        <% }%>        
    </body>
</html>
