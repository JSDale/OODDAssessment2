<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Train Ticket Gate Example</title>
    </head>

    <table>
        <tr>
            <td>
                <img src="./images/gate.jpg" alt="Ticket Gate">
        </tr>
    </table>

    <body>
        <h1>Train Ticket Gate Example</h1>
        <p><a href="./generateTicket.jsp" target="_blank" >Generate Ticket</a></p>
        <p><a href="./openGate.jsp" target="_blank" >Open Gate With Ticket</a></p>

        <h1>ReST End Points</h1>
        <p><a href="http://localhost:8080/ticketgate/rest/gatelock" target="_blank" >GET http://localhost:8080/ticketgate/rest/gatelock Tests interface active</a></p>
        <p><a href="http://localhost:8080/ticketgate/rest/gatelock/openGate/1/" target="_blank" >POST http://localhost:8080/ticketgate/rest/gatelock/openGate/1/ Opens a gate with a ticket</a></p>
        <p><a href="http://localhost:8080/ticketgate/rest/gatelock/createTicket/" target="_blank" >POST http://localhost:8080/ticketgate/rest/gatelock/createTicket/ Creates a ticket</a></p>
      
        <p>(see the example Rester configuration included in this project to run example POST calls against the ReST interface)</p>
    </body>
</html>
