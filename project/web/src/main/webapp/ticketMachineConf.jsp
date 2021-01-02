<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%-- 
    Document   : ticketMachineConf
    Created on : 31 Dec 2020, 12:19:24
    Author     : Jacob
--%>
<%@page import="java.util.UUID"%>
<%@page import="org.solent.com528.project.model.dao.TicketMachineDAO"%>
<%@page import="org.solent.com528.project.model.dao.StationDAO"%>
<%@page import="org.solent.com528.project.impl.web.WebObjectFactory"%>
<%@page import="org.solent.com528.project.model.service.ServiceFacade"%>
<%@page import="java.util.List"%>
<%@page import="org.solent.com528.project.model.dto.Station"%>
<%@page import="org.solent.com528.project.model.dto.TicketMachine"%>
<%
    String errorMessage = "";
    String message = "";
    String stationName = "UNASSIGNED";
    ServiceFacade serviceFacade = (ServiceFacade) WebObjectFactory.getServiceFacade();
    StationDAO stationDAO = serviceFacade.getStationDAO();
    TicketMachineDAO machineDAO = serviceFacade.getTicketMachineDAO();
    List<Station> stationList = stationDAO.findAll();
    TicketMachine ticketMachine = new TicketMachine();
    Station tempStation = null;
    
    String originalMachineUuid = request.getParameter("TicketMachineUuid");
    if(originalMachineUuid == null || originalMachineUuid.isEmpty())
    {
        errorMessage = "Something went wrong with UUID";
        System.exit(1);
    }
    
    String machineIdStr = request.getParameter("TicketMachineId");
    if(machineIdStr == null || machineIdStr.isEmpty())
    {
        machineIdStr = "-1";
    }
    Long machineId= Long.parseLong(machineIdStr);
    
    String stationNameStr = request.getParameter("stationName");
    if(stationNameStr == null || stationNameStr.isEmpty())
    {
        stationNameStr = "UNASSIGNED";
    }
    
    if(!stationNameStr.equals("UNASSIGNED"))
    {
        tempStation = stationDAO.findByName(stationNameStr);
    }
    
    String actionStr = request.getParameter("action");
    if(actionStr == null || actionStr.isEmpty())
    {
        actionStr = "";
    }
    
    if(actionStr.equals("createTicketMachine"))
    {
        TicketMachine tempMachine = new TicketMachine();
        Long id = UUID.randomUUID().getLeastSignificantBits() & Long.MAX_VALUE;
        String uuid = UUID.randomUUID().toString();
        tempMachine.setId(id);
        tempMachine.setUuid(uuid);
        tempMachine.setStation(null);
        
        machineDAO.save(tempMachine);
        message = "new ticket machine created, assign a station to it please.";
    }
    
    if(actionStr.equals("updateMachineUuid"))
    {
        String newUuid = request.getParameter("updateTicketMachineUuid");
        if(newUuid == null || newUuid.isEmpty())
        {
            errorMessage = "please enter a UUID.";
            return;
        }
        TicketMachine tempTicketMachine = new TicketMachine();
        tempTicketMachine.setStation(tempStation);
        tempTicketMachine.setId(machineId);
        tempTicketMachine.setUuid(originalMachineUuid);
        try{
        machineDAO.deleteById(machineId);
         
        tempTicketMachine.setUuid(newUuid);
        
        machineDAO.save(tempTicketMachine);
        
        message = "Machine updated!";
        }
        catch(Exception ex)
        {
            errorMessage = "something went wrong";
        }
    }
        
        if(actionStr.equals("updateMachineStation"))
    {
        String newStationStr = request.getParameter("stationName");
        String originalStationName = request.getParameter("originalStationName");
        Station replacedStation = stationDAO.findByName(originalStationName);
        Station replacementStation = stationDAO.findByName(newStationStr);
        TicketMachine tempTicketMachine = new TicketMachine();
        tempTicketMachine.setStation(replacedStation);
        tempTicketMachine.setId(machineId);
        tempTicketMachine.setUuid(originalMachineUuid);
        try{
        machineDAO.deleteById(machineId);
         
        tempTicketMachine.setStation(replacementStation);
        
        machineDAO.save(tempTicketMachine);
        
        message = "Machine updated!";
        }
        catch(Exception ex)
        {
            errorMessage = "something went wrong";
        }
    }
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Ticket Machine</title>
    </head>
    <body>

        <H1>Ticket Machine <%=originalMachineUuid%></H1>
        <!-- print error message if there is one -->
        <div style="color:red;"><%=errorMessage%></div>
        <div style="color:green;"><%=message%></div>

        <br>
        <form action="./ticketMachineList.jsp" method="get">
            <button type="submit" >Return to Ticket Machine List</button>
        </form> 
        <br>
        <!-- if you used method post the url parameters would be hidden -->
        <form action="./ticketMachineConf.jsp" method="get">
            <p>Ticket Machine UUID: <input type="text" size="36" name="updateTicketMachineUuid" value="<%=originalMachineUuid%>">
                <input type="hidden" name="TicketMachineUuid" value="<%=ticketMachine.getUuid()%>">
                <input type="hidden" name="originalUuid" value="<%=originalMachineUuid%>">
                <input type="hidden" name="TicketMachineId" value="<%=machineId%>">
                <input type="hidden" name="action" value="updateMachineUuid">
                <input type="hidden" name="stationName" value="stationNameStr">
                <button type="submit" >Update Ticket Machine UUID</button>
            </p>
        </form>
        <form>
            <table>
             <tr>
                <td>Station:</td>
                <td>
                    <select name="stationName" id="cboStartStation">
                        <option value="UNDEFINED">--Select--</option>
                         <%
                            String tempStationName = "";
                            for (Station station : stationList) 
                            {
                                if(!tempStationName.equals(station.getName()))
                                {
                                    tempStationName = station.getName();
                                    %>
                       <option value="<%=station.getName()%>"><%=station.getName()%></option>
                    <%
                            }
                        }
                    %>
                        <option value="UNDEFINED">--Select--</option>
                    </select>
                    <%
                        stationName = request.getParameter("stationName");
                    %>
                </td>
                <td>
                    <input type="hidden" name="TicketMachineUuid" value="<%=originalMachineUuid%>">
                    <input type="hidden" name="TicketMachineId" value="<%=machineId%>">
                    <input type="hidden" name="stationName" value="stationNameStr">
                    <input type="hidden" name="originalStationName" value="<%=stationNameStr%>">
                    <input type="hidden" name="action" value="updateMachineStation">
                    <button type="submit">add ticket machine to station</button>
                </td>
            </tr>
         </table>
         </form>
        <br>
       <form action="./ticketMachineConf.jsp" method="get">
           <p>The assigned station for this machine is: <%= stationName %></p>
            <input type="hidden" name="action" value="removeMachineStation">
            <button type="submit" >remove ticket machine from station</button>
        </form>
    </body>
</html>
