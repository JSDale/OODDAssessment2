<%-- 
    Document   : openGate
    Created on : 10 Dec 2020, 11:00:58
    Author     : Jacob
--%>

<%@page import="java.util.Date"%>
<%@page import="org.solent.com528.project.model.util.DateTimeAdapter"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%
    String errorMessage = "";

    //GateEntryService gateEntryService = ServiceFactoryImpl.getGateEntryService();
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
