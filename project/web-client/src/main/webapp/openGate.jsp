<%-- 
    Document   : openGate
    Created on : 28 Dec 2020, 10:32:50
    Author     : Jacob
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String errorMessage = "Gate Closed";
    String ticketStr = "";
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage Gate Locks</title>
    </head>
    <body>
        <h1>Open Gate</h1>
        <form action="./openGate.jsp"  method="post">
            <table>
                <tr>Enter Ticket:</tr>
                <tr>
                    <td><textarea id="ticketTextArea" rows="10" cols="120" readonly><%=ticketStr%></textarea></td>
                </tr>
            </table>
            <button type="submit" >Open Gate</button>
        </form>
        <div style="color:red; font-size: 64px; padding-top: 50px;"><%=errorMessage%></div>        
    </body>
</html>
