<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%-- 
    Document   : ticketMachineList
    Created on : 31 Dec 2020, 11:55:27
    Author     : Jacob
--%>

<%@page import="org.solent.com528.project.model.dto.Station"%>
<%@page import="java.util.List"%>
<%@page import="org.solent.com528.project.model.dao.TicketMachineDAO"%>
<%@page import="org.solent.com528.project.impl.web.WebObjectFactory"%>
<%@page import="org.solent.com528.project.model.service.ServiceFacade"%>
<%@page import="org.solent.com528.project.model.dto.TicketMachine"%>
<%@page import="java.util.Date"%>
<%
     // used to set html header autoload time. This automatically refreshes the page
    // Set refresh, autoload time every 20 seconds
    response.setIntHeader("Refresh", 20);
    String errorMessage = "";
    String message = "";
    ServiceFacade serviceFacade = (ServiceFacade) WebObjectFactory.getServiceFacade();
    TicketMachineDAO machineDAO = serviceFacade.getTicketMachineDAO();
    List<TicketMachine> ticketMachineList = machineDAO.findAll();
    String errorMessageAction = "Something went wrong, action couldn't be completed";
    
    String actionStr = request.getParameter("action");
    if( actionStr == null || actionStr.isEmpty())
    {
        actionStr = "";
    }
    
    if(actionStr.equals("deleteTicketMachine"))
    {
        try
        {
            String machineIdStr = request.getParameter("TicketMachineId");
            Long tempMachineId = Long.parseLong(machineIdStr);
             machineDAO.deleteById(tempMachineId);
        }
        catch(Exception ex)
        {
            errorMessage = errorMessageAction;
        }
    }
    
    if(actionStr.equals("deleteAllTicketMachines"))
       {
           try
           {
                machineDAO.deleteAll();
           }
           catch(Exception ex)
           {
               errorMessage = errorMessageAction;
           }
       }
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Ticket Machine List</title>
    </head>
    <body>

        <H1>Ticket Machine List</H1>
        <!-- print error message if there is one -->
        <div style="color:red;"><%=errorMessage%></div>
        <div style="color:green;"><%=message%></div>

        <p>The time is: <%= new Date().toString()%> (note page is auto refreshed every 20 seconds)</p>

        <form action="./ticketMachineConf.jsp" method="get">
            <input type="hidden" name="action" value="createTicketMachine">
            <button type="submit" >Create New Ticket Machine</button>
        </form> 
        <br>
        <form action="./ticketMachineList.jsp" method="get">
            <input type="hidden" name="action" value="deleteAllTicketMachines">
            <button type="submit" style="color:red;">Delete All Ticket Machines</button>
        </form> 
        <br>

        <table border="1">
            <tr>
                <th>Ticket Machine Name</th>
                <th>Ticket Machine Station</th>
            </tr>
            <%
                String tempStationName = "";
                for (TicketMachine machine : ticketMachineList) {
                    if(!tempStationName.equals(machine.getUuid()))
                    {
                        tempStationName = machine.getUuid();
            %>
            <tr>
                <td size="36" ><%=machine.getUuid()%></td>
                <%
                    Station station = new Station();
                    try
                    {
                        station = machine.getStation();
                        if(station == null)
                        {
                            station = new Station();
                            station.setName("UNASSIGNED");
                        }
                    }
                    catch(Exception ex)
                    {
                        station = new Station();
                        station.setName("UNASSIGNED");
                    }
                %>
                <td size="36" >&nbsp;<%=station.getName()%></td>
                <td>
                    <form action="./ticketMachineConf.jsp" method="get">
                        <input type="hidden" name="stationName" value="<%=station.getName()%>">
                        <input type="hidden" name="TicketMachineUuid" value="<%=machine.getUuid()%>">
                         <input type="hidden" name="TicketMachineId" value="<%=machine.getId()%>">
                        <input type="hidden" name="action" value="modifyTicketMachine">
                        <button type="submit" >Modify Ticket Machine</button>
                    </form> 
                </td>
                <td>
                    <form action="./ticketMachineList.jsp" method="get">
                        <input type="hidden" name="stationName" value="<%=station.getName()%>">
                        <input type="hidden" name="TicketMachineId" value="<%=machine.getId()%>">
                        <input type="hidden" name="action" value="deleteTicketMachine">
                        <button type="submit" style="color:red;" >Delete Ticket Machine</button>
                    </form> 
                </td>
            </tr>
            <%
                    }
                }
            %>
        </table> 
    </body>
</html>
