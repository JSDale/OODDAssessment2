<%-- 
    Document   : AssignMachineToStation
    Created on : 31 Dec 2020, 10:36:47
    Author     : Jacob
--%>

<%@page import="org.solent.com528.project.model.dto.TicketMachine"%>
<%@page import="java.util.List"%>
<%@page import="org.solent.com528.project.impl.web.WebObjectFactory"%>
<%@page import="org.solent.com528.project.model.dao.TicketMachineDAO"%>
<%@page import="org.solent.com528.project.impl.dao.jpa.TicketMachineDAOJpaImpl"%>
<%@page import="org.solent.com528.project.model.service.ServiceFacade"%>
<%
    String errorMessage = "";
    String message = "";
    String ticketMachineUuidStr = null;
    ServiceFacade serviceFacade = (ServiceFacade) WebObjectFactory.getServiceFacade();
    TicketMachineDAO ticketMachineDAO = serviceFacade.getTicketMachineDAO();
    List<TicketMachine> ticketMachineList = ticketMachineDAO.findAll();
    
    String stationName = request.getParameter("stationName");
    if (stationName == null) 
    {
        errorMessage = "stationName must be a parameter for removeTicketMachine";
    }
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Assign Ticket Machine to Station</title>
    </head>
    <body>
       <H1>Station <%=stationName%></H1>
        <!-- print error message if there is one -->
        <div style="color:red;"><%=errorMessage%></div>
        <div style="color:green;"><%=message%></div>
         <table>
                <tr>
                    <td>Start Station:</td>
                    <td>
                        <select name="ticketMachineUUID" id="cboStartStation">
                            <option value="UNDEFINED">--Select--</option>
                             <%
                                for (TicketMachine ticketMachine : ticketMachineList) {
                            %>
                           <option value="<%=ticketMachine.getUuid()%>"><%=ticketMachine.getUuid()%></option>
                            <%
                                }
                            %>
                            <option value="UNDEFINED">--Select--</option>
                        </select>
                        <%
                            ticketMachineUuidStr = request.getParameter("ticketMachineUUID");
                        %>
                    </td>
                </tr>
         </table>
    </body>
</html>
