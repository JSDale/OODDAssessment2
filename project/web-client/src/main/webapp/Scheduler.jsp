<%-- 
    Document   : Scheduler
    Created on : 2 Jan 2021, 12:52:25
    Author     : Jacob
--%>

<%@page import="org.solent.com528.project.impl.webclient.WebClientObjectFactory"%>
<%@page import="org.solent.com528.project.model.dto.PricingDetails"%>
<%@page import="org.solent.com528.project.model.dao.PriceCalculatorDAO"%>
<%@page import="org.solent.com528.project.model.service.ServiceFacade"%>
<%@page import="java.util.Date"%>
<%@page import="org.solent.com528.project.impl.webclient.DateTimeAdapter"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // used to set html header autoload time. This automatically refreshes the page
    // Set refresh, autoload time every 20 seconds
    response.setIntHeader("Refresh", 10);
    String errorMessage = "";
    String message = "";
    
    String actionStr = request.getParameter("action");
    if(actionStr == null || actionStr.isEmpty())
    {
        actionStr = "";
    }
    
    String newPeakPriceStr = "";
    String newOffPeakPriceStr = "";
    ServiceFacade cleintServiceFacade = (ServiceFacade) WebClientObjectFactory.getServiceFacade();
    PriceCalculatorDAO priceCalcDAO = cleintServiceFacade.getPriceCalculatorDAO();
    double currentOffPeakPriceDbl = priceCalcDAO.getOffpeakPricePerZone();
    double currentPeakPriceDbl = priceCalcDAO.getPeakPricePerZone();
    
    
    String currentOffPeakPriceStr = null;
    String currentPeakPriceStr = null;
    try
    {
        currentOffPeakPriceStr = String.valueOf(currentOffPeakPriceDbl);
        currentPeakPriceStr = String.valueOf(currentPeakPriceDbl);
    }
    catch(Exception ex)
    {
        errorMessage = "off peak / peak price couldn't be converted.";
    }
    
    if(actionStr.equals("updatePrice"))
    {
        String newPeakPrice = request.getParameter("newPeakPricing");
        String newOffPeakPrice = request.getParameter("newOffPeakPricing");
        double newPeakPriceDbl = -1;
        double newOffPeakPriceDbl = -1;
        
        if(!newPeakPrice.equals(""))
        {
            try
            {
                newPeakPriceDbl = Double.parseDouble(newPeakPrice);
            }
            catch(Exception ex)
            {
                errorMessage = "please ensure new peak price is a valid number";
            }
        }
        
         if(!newOffPeakPrice.equals(""))
        {
            try
            {
                newOffPeakPriceDbl = Double.parseDouble(newOffPeakPrice);
            }
            catch(Exception ex)
            {
                errorMessage = "please ensure new off peak price is a valid number";
            }
        }
        
        if(newPeakPriceDbl != -1 || newOffPeakPriceDbl != -1)
        {
            try
            {
                PricingDetails pd = new PricingDetails();
                pd.setOffpeakPricePerZone(newOffPeakPriceDbl);
                pd.setPeakPricePerZone(newPeakPriceDbl);
                priceCalcDAO.savePricingDetails(pd);
                
                message = "updated price info";
            }
            catch(Exception ex)
            {
                errorMessage = "couldn't update price info.";
            }
            
            
        }
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
        <form action="./Scheduler.jsp"  method="get">
            <table>
                    <tr>
                    <td>Current Pricing Off Peak (per zone): </td>
                    <td><input type="text" name="currentOffPeakPrice" value="<%=currentOffPeakPriceStr%>" readonly></td>
                    </tr>
                    <tr>
                        <td>Current Pricing Peak (per zone): </td>
                       <td><input type="text" name="currentPeakPrice" value="<%=currentPeakPriceStr%>" readonly></td>
                    </tr>
                <tr>
                    <td>Enter new peak pricing:</td>
                    <td>
                        <input type="text" name="newPeakPricing" value="<%=newPeakPriceStr%>">
                    </td>
                </tr>
                 <tr>
                    <td>Enter new off peak pricing:</td>
                    <td>
                        <input type="text" name="newOffPeakPricing" value="<%=newOffPeakPriceStr%>">
                        <input type="hidden" name="action" value="updatePrice">
                    </td>
                </tr>
                <tr>
                <tr><td style='color:red'>leave text area blank if you don't want it to be changed</td></tr>
                    <td>
                        <button type="submit">Change Pricing(s)</button>
                    </td>
                </tr>
            </table>
        </form>
    <p>Click <a href="timeScheduler.jsp">here</a> to change the times of Peak and Off Peak</p>
    </body>
</html>
