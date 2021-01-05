<%-- 
    Document   : changeConfig
    Created on : 16 Dec 2020, 00:39:54
    Author     : cgallen
--%>

<%@page import="org.solent.com528.project.model.dto.TicketMachineConfig"%>
<%@page import="org.solent.com528.project.model.dto.TicketMachine"%>
<%@page import="org.solent.com528.project.model.dao.TicketMachineDAO"%>
<%@page import="java.util.Date"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="org.solent.com528.project.impl.webclient.WebClientObjectFactory"%>
<%@page import="org.solent.com528.project.model.service.ServiceFacade"%>

<%
    // used to place error message at top of page 
    String errorMessage = "";
    String message = "";

    // accessing service 
    ServiceFacade serviceFacade = (ServiceFacade) WebClientObjectFactory.getServiceFacade();

    // accessing request parameters
    String actionStr = request.getParameter("action");
    if(actionStr == null || actionStr.isEmpty())
    {
        actionStr = "";
    }
    String updateUuidStr = request.getParameter("updateUuid");

    String stationName = WebClientObjectFactory.getStationName();
    Integer stationZone = WebClientObjectFactory.getStationZone();
    String ticketMachineUuid = request.getParameter("updateUuid");
    if(ticketMachineUuid == null || ticketMachineUuid.isEmpty())
    {
        WebClientObjectFactory.getTicketMachineUuid();
    }
    Date lastUpdate = WebClientObjectFactory.getLastClientUpdateTime();
    Date lastUpdateAttempt = WebClientObjectFactory.getLastClientUpdateAttempt();
    String lastUpdateStr = (lastUpdate==null) ? "not known" : lastUpdate.toString();
    String lastUpdateAttemptStr = (lastUpdateAttempt==null) ? "not known" : lastUpdateAttempt.toString();
    
    if(actionStr.equals("changeTicketMachineUuid"))
    {
        try
        {
            TicketMachineConfig ticketMachineConfig = serviceFacade.getTicketMachineConfig(ticketMachineUuid);
            stationName = ticketMachineConfig.getStationName();
            stationZone = ticketMachineConfig.getStationZone();
            WebClientObjectFactory.setTicketMachineUuid(ticketMachineUuid);
        }
        catch(Exception ex)
        {
            errorMessage = "Machine couldn't update. Check that the UUID exists.";
        }
    }

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Change Ticket Machine Configuration</title>
    </head>
    <body>

        <h1>Change Ticket Machine Configuration</h1>
        <div style="color:red;"><%=errorMessage%></div>
        <div style="color:green;"><%=message%></div>

        <table>
            <tr>
                <td>Last Update Attempt</td>
                <td><%=lastUpdateAttemptStr %></td>
            </tr>
            <tr>
                <td>Last Successfull Update </td>
                <td><%=lastUpdateStr %></td>
            </tr>
            <tr>
                <td>Station Name</td>
                <td><%=stationName%></td>
            </tr>
            <tr>
                <td>Station Zone</td>
                <td><%=stationZone%></td>
            </tr>
            <tr>
            <form action="./changeConfig.jsp" method="get">
                <tr>
                    <td>Ticket Machine Uuid</td>
                    <td><input type="text" size="36" name="updateUuid" value="<%=ticketMachineUuid%>"></td>
                    <td>
                        <input type="hidden" name="action" value="changeTicketMachineUuid">
                        <button type="submit" >Change Ticket Machine Uuid</button>
                    </td>
                </tr>
            </form>
            <form action="./index.jsp" method="post">
                <tr>
                <td><button type="submit" >Return to index</button></td>
                </tr>
            </form>
        </table> 

    </body>
</html>
