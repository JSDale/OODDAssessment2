<%-- 
    Document   : TicketMachine
    Created on : 22 Dec 2020, 10:38:27
    Author     : Jacob
--%>

<%@page import="org.solent.com528.project.model.dao.PriceCalculatorDAO"%>
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
    PriceCalculatorDAO priceCalcDAO = serviceFacade.getPriceCalculatorDAO();
    List<Station> stationList =  stationDAO.findAll();
    String ticketStr = "";

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
    if (endStationStr == null || endStationStr.isEmpty()) {
        endStationStr = "UNDEFINED";
    }
    String priceStr = request.getParameter("price");
    if (priceStr == null || priceStr.isEmpty()) {
        priceStr = "00.00";
    }
    String cardNoStr = request.getParameter("cardNo");
    if(cardNoStr == null || cardNoStr.isEmpty()){
        cardNoStr ="";
    }
    
    int cardNo = 0;
    try{
        cardNo = Integer.parseInt(cardNoStr);
    }
    catch(Exception ex)
    {
        cardNo = 0;
    }
    boolean cardIsReal = false;
    if(cardNoStr.length() == 16)
    {
        cardIsReal = true;
    }
    
    if (startStationStr != "UNDEFINED" && endStationStr != "UNDEFINED") {
           Date validFromDate = df.parse(validFromStr);

           double pricePerZone = priceCalcDAO.getPricePerZone(validFromDate);

          Station startStation = stationDAO.findByName(startStationStr);
          int startStationZone =  startStation.getZone();

           Station endStation = stationDAO.findByName(endStationStr);
          int endStationZone =  endStation.getZone();
          int zoneDif = 1;
          if(startStationZone > endStationZone)
          {
               zoneDif = startStationZone - endStationZone;
          }
          else if(startStationZone < endStationZone)
          {
                zoneDif = endStationZone - startStationZone;
          }
          
          double price = zoneDif * pricePerZone;
          priceStr = "£"+price;
   }
   
    
    
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
                        <select name="startStation" id="cboStartStation">
                            <option value="UNDEFINED">--Select--</option>
                             <%
                                for (Station station : stationList) {
                            %>
                           <option value="<%=station.getName()%>"><%=station.getName()%></option>
                            <%
                                }
                            %>
                            <option value="UNDEFINED">--Select--</option>
                        </select>
                        <%
                            startStationStr = request.getParameter("startStation");
                        %>
                    </td>
                </tr>
                <tr>
                    <td>End Station:</td>
                    <td>
                         <select name="endStation" id="cboEndStation" onchnage="submit">
                             <option value="UNDEFINED">--Select--</option>
                             <%
                                for (Station station : stationList) {
                            %>
                           <option value="<%=station.getName()%>"><%=station.getName()%></option>
                            <%
                                }
                            %>
                            <option value="UNDEFINED">--Select--</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>Valid From Time:</td>
                    <td><input type="text" name="validFrom" value="<%=validFromStr%>"></td>
                </tr>
                <tr>
                    <td>Valid To Time:</td>
                    <td><input type="text" name="validTo" value="<%=validToStr%>" readonly></td>
                </tr>
            </table>
            <button type="submit">Checkout</button>
        </form> 
        <h1>Checkout</h1><form action="./TicketMachine.jsp"  method="post">
            <table>
                <tr>
                    <td>Price:</td>
                    <td><input type="text" name="price" value="<%=priceStr%>" readonly></td>
                </tr>                
                 <tr>
                    <td>Enter Card Number:</td>
                    <td><input type="text" name="cardNo" value="<%=cardNoStr%>"></td>
                </tr>
                <tr>
                    <td>Printed Ticket</td>
                    <td><input type="text" id="ticketText" value="<%=ticketStr%>" readonly></td>
                </tr>
            </table>
            <button type="submit" >Buy Ticket</button>
        </form>
    </body>
</html>
