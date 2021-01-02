<%-- 
    Document   : Scheduler
    Created on : 2 Jan 2021, 12:52:25
    Author     : Jacob
--%>

<%@page import="org.solent.com528.project.impl.web.WebObjectFactory"%>
<%@page import="org.solent.com528.project.model.dao.PriceCalculatorDAO"%>
<%@page import="org.solent.com528.project.model.service.ServiceFacade"%>
<%@page import="java.util.Date"%>
<%@page import="org.solent.com528.project.impl.webclient.DateTimeAdapter"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String errorMessage = "";
    String message = "";
    DateFormat df = new SimpleDateFormat(DateTimeAdapter.DATE_FORMAT);
    ServiceFacade cleintServiceFacade = (ServiceFacade) WebObjectFactory.getClientServiceFacade();
    PriceCalculatorDAO priceCalcDAO = cleintServiceFacade.getPriceCalculatorDAO();
    double currentOffPeakPriceDbl = priceCalcDAO.getOffpeakPricePerZone();
    
    String currentOffPeakPriceStr = null;
    try
    {
        currentOffPeakPriceStr = String.valueOf(currentOffPeakPriceDbl);
    }
    catch(Exception ex)
    {
        errorMessage = "off peak price couldn't be converted.";
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Pricing Schedule</title>
    </head>
    <body>
        <h1>Change Pricing Schedule</h1>
        <div style="color:red;"><%=errorMessage%></div>
        <div style="color:green;"><%=message%></div>
        <form action="./Scheduler.jsp"  method="post">
            <table>
                <tr>
                    <td>Current Pricing Off Peak (per zone): </td>
                   <td><input type="text" name="currentOffPeakPrice" value="<%=currentOffPeakPriceStr%>" readonly></td>
                </tr>
                
            </table>
        </form>
        
    </body>
</html>
