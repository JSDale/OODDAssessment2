<%
    String machineUuid = "test";
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
<html>
    <head>
        <title>Client Ticket Machine Start Page</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    </head>
    <body>
        <h1>Client Ticket Machine Start Page</h1>

        <div>
            <img src="./images/gate.jpg" alt="London Underground Gate" style="width:200px;height:300px;">
        </div>

        <h2>Client Ticket Machine</h2>
        <!-- http://localhost:8080/projectfacadeweb-client/clientstationList.jsp -->
        <p> click on <a href="../projectfacadeweb-client/clientstationList.jsp">clientstationList.jsp</a> to open client ticket machine application
        </p>
        <p> click on <a href="../projectfacadeweb-client/changeConfig.jsp">changeConfig.jsp</a> to change client ticket machine configuration
        </p>
        <form action="../projectfacadeweb-client/TicketMachine.jsp" method="get">
        <p> click on the buy a ticket button to buy a ticket </p>
        <input type="hidden" name="ticketMachineUuid" value ="<%=machineUuid%>">
        <button>buy a ticket</button>
        </form>
        <p> click on <a href="../projectfacadeweb-client/openGate.jsp">openGate.jsp</a> to leave the station
        </p>
        <p> click on <a href="../projectfacadeweb-client/Scheduler.jsp">Scheduler.jsp</a> to edit pricing(s).
        </p>


    </body>
</html>