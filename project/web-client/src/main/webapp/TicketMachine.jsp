<%-- 
    Document   : TicketMachine
    Created on : 22 Dec 2020, 10:38:27
    Author     : Jacob
--%>
<%@page import="org.solent.com528.project.model.dto.TicketMachineConfig"%>
<%@page import="java.net.URL"%>
<%@page import="org.solent.com528.project.impl.webclient.TicketLogger"%>
<%@page import="java.util.Set"%>
<%@page import="org.solent.com528.project.clientservice.impl.TicketEncoderImpl"%>
<%@page import="org.solent.com528.project.impl.webclient.TicketInformation"%>
<%@page import="org.solent.com528.project.model.dto.Rate"%>
<%@page import="org.solent.com528.project.model.dto.Ticket"%>
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
    PriceCalculatorDAO priceCalcDAO = serviceFacade.getPriceCalculatorDAO();
    String ticketMachineUuid = WebClientObjectFactory.getTicketMachineUuid();
    if(ticketMachineUuid.isEmpty())
    {
        ticketMachineUuid = null;
    }
    
    double offPeakPricePerZone = priceCalcDAO.getOffpeakPricePerZone();
    double peakPricePerZone = priceCalcDAO.getPeakPricePerZone();
    
    TicketMachineConfig ticketMachineConf = serviceFacade.getTicketMachineConfig(ticketMachineUuid);
    List<Station> stationList = new ArrayList();
    try
    {
        stationList = ticketMachineConf.getStationList();
    }
    catch(Exception ex)
    {
        errorMessage = "Ticket machine UUID is invalid";
    }
    String ticketStr = "";
    String actionStr = request.getParameter("action");
    if(actionStr == null || actionStr.isEmpty())
    {
        actionStr = "";
    }

    // pull in standard date format
    DateFormat df = new SimpleDateFormat(DateTimeAdapter.DATE_FORMAT);

    String validFromStr = request.getParameter("validFrom");
    if (validFromStr == null || validFromStr.isEmpty()) {
        validFromStr = df.format(new Date());
    }
    
    String startStationStr = "UNDEFINED";
    if(!stationList.isEmpty())
    {
        ticketMachineConf.getStationName();
        startStationStr = ticketMachineConf.getStationName();
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

    if (startStationStr != "UNDEFINED" && endStationStr != "UNDEFINED") {
            Date validFromDate =null;
            boolean dateTimeValid = false;
            try
            {
                validFromDate = df.parse(validFromStr);
                dateTimeValid = true;
            }
            catch(Exception ex)
            {
                errorMessage = "The Date Time is invalid";
            }
            
            if(dateTimeValid)
            {
            boolean stationExists = false;
            double pricePerZone = priceCalcDAO.getPricePerZone(validFromDate);
            Station endStation = null;

            for(Station station : stationList)
            {
                if(station.getName().equals(endStationStr))
                {
                    endStation = station;
                    stationExists = true;
                }
            }

            if(stationExists)
            {
                int startStationZone =  ticketMachineConf.getStationZone();
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
                if(zoneDif == 0){ zoneDif = 1; }
                double price = zoneDif * pricePerZone;
                priceStr = "£"+price;

                TicketInformation.StartStation = startStationStr;
                TicketInformation.validFrom = validFromDate;
                TicketInformation.price = price;
                TicketInformation.zonesTravelable = zoneDif;
            }
            else
            {
                errorMessage = "station doesn't exsist, or there is a problem with station UUID.";
            }
        }       

    }

    if(actionStr.equals("buyTicket"))
    {
        long cardNo = 0;
        try{
            cardNo = Long.parseLong(cardNoStr);
        }
        catch(Exception ex)
        {
            errorMessage = "card is invalid parse error";
        }
        boolean cardIsReal = false;
        if(cardNoStr.length() == 16 && cardNo != 0)
        {
            cardIsReal = true;
        }

        if(cardIsReal)
        {
            Rate rate = priceCalcDAO.getRate(TicketInformation.validFrom);
            Ticket ticket = new Ticket();
            ticket.setCost(TicketInformation.price);
            ticket.setIssueDate(TicketInformation.validFrom);
            ticket.setStartStation(TicketInformation.StartStation);
            ticket.setRate(rate);
            ticket.setId();
            ticket.setNumberOfZones(TicketInformation.zonesTravelable);
            String encodedTicket =  TicketEncoderImpl.encodeTicket(ticket);
            String[] encodedTicketSplit = encodedTicket.split("<encryptedHash>");
            encodedTicketSplit = encodedTicketSplit[1].split("</encryptedHash");
            String hash = encodedTicketSplit[0];
            ticket.setEncryptedHash(hash);

            ticketStr = encodedTicket;

            TicketLogger ticketLogger = new TicketLogger();
            ticketLogger.LogTicketAsXML(encodedTicket);
        }
        else
        {
            errorMessage = "card is invalid";
        }
    }
   
%>


<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Purchase Ticket</title>
    </head>
    <body>
        <h1>Station: <%=startStationStr%></h1>
        <h1>Generate a New Ticket</h1>
        <!-- print error message if there is one -->
        <div style="color:red;"><%=errorMessage%></div>

        <form action="./TicketMachine.jsp"  method="post">
            <table>
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
            </table>
            <button type="submit">Checkout</button>
        </form> 
        <h1>Checkout</h1><form action="./TicketMachine.jsp"  method="get">
            <table>
                <tr>
                    <td>Price:</td>
                    <td><input type="text" name="price" value="<%=priceStr%>" readonly></td>
                </tr>                
                 <tr>
                    <td>Enter Card Number:</td>
                    <td><input type="text" name="cardNo" value="<%=cardNoStr%>"></td>
                </tr>
            </table>
            <button type="submit" name="action" value="buyTicket" >Buy Ticket</button>
        </form>
        <h2>Printed Ticket</h2>
        <textarea id="ticketTextArea" rows="15" cols="150" readonly><%=ticketStr%></textarea>
    </body>
</html>
