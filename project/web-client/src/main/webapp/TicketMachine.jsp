<%-- 
    Document   : TicketMachine
    Created on : 22 Dec 2020, 10:38:27
    Author     : Jacob
--%>

<%@page import="org.solent.com528.project.model.service.ServiceFacade"%>
<%@page import="org.solent.com528.project.impl.webclient.WebClientObjectFactory"%>
<%@page import="org.solent.com528.project.model.dao.StationDAO"%>
<%@page import="org.solent.com528.project.model.dto.Station"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.solent.com528.project.impl.webclient.DateTimeAdapter"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Date"%>

<%
    String errorMessage = "";
    ServiceFacade serviceFacade = (ServiceFacade) WebClientObjectFactory.getServiceFacade();
    StationDAO stationDAO = serviceFacade.getStationDAO();
    List<Station> stationList =  stationDAO.findAll();

    // pull in standard date format
    DateFormat df = new SimpleDateFormat(DateTimeAdapter.DATE_FORMAT);
    
     String validFromStr = request.getParameter("validFrom");
    if (validFromStr == null || validFromStr.isEmpty()) {
        validFromStr = df.format(new Date());
    }

    String validToStr = request.getParameter("validTo");
    // valid to initialised to date plus one day
    if (validToStr == null || validToStr.isEmpty()) {
        validToStr = df.format(new Date(new Date().getTime() + 1000 * 60 * 60 * 24));
    }
        
    String startStationStr = request.getParameter("startStation");
    if (startStationStr == null || startStationStr.isEmpty()) {
        startStationStr = "UNDEFINED";
    }
    
    String endStationStr = request.getParameter("endStation");
    if (endStationStr == null || startStationStr.isEmpty()) {
        endStationStr = "UNDEFINED";
    }

    
    String ticketStr = "";
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage gate Locks</title>
    </head>
    <body>
        <h1>Generate a New Ticket</h1>
        <!-- print error message if there is one -->
        <div style="color:red;"><%=errorMessage%></div>

        <form action="./TicketMachine.jsp"  method="post">
            <table>
                <tr>
                    <td>Start Station:</td>
                    <td>
                        <select name="cboItems" id="cboItems">
                            <option value="<%=startStationStr%>">--Select--</option>
                             <%
                                for (Station station : stationList) {
                            %>
                           <option value="<%=startStationStr%>"><%=station.getName()%></option>
                            <%
                                }
                            %>
                            <option value="<%=startStationStr%>">--Select--</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>End Station:</td>
                    <td>
                         <select name="cboItems" id="cboItems">
                             <option value="<%=startStationStr%>">--Select--</option>
                             <%
                                for (Station station : stationList) {
                            %>
                           <option value="<%=startStationStr%>"><%=station.getName()%></option>
                            <%
                                }
                            %>
                            <option value="<%=startStationStr%>">--Select--</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>Valid From Time:</td>
                    <td><input type="text" name="validFrom" value="<%=validFromStr%>"></td>
                </tr>
                <tr>
                    <td>Valid To Time:</td>
                    <td><input type="text" name="validTo" value="<%=validToStr%>"></td>
                </tr>
            </table>
            <button type="submit" >Create Ticket</button>
        </form> 
        <h1>generated ticket XML</h1>
        <textarea id="ticketTextArea" rows="10" cols="120"><%=ticketStr%></textarea>

    </body>
</html>
