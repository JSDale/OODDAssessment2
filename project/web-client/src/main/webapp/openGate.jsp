<%-- 
    Document   : openGate
    Created on : 28 Dec 2020, 10:32:50
    Author     : Jacob
--%>

<%@page import="org.solent.com528.project.clientservice.impl.TicketEncoderImpl"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
String errorMessage = "";
boolean isValid = false;

String ticketStr = request.getParameter("ticketTextArea");
    if (ticketStr == null || ticketStr.isEmpty()) {
        ticketStr = "";
    }

if(ticketStr != "")
{
    isValid = TicketEncoderImpl.validateTicket(ticketStr);
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
