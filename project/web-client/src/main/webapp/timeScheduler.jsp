<%-- 
    Document   : timeScheduler
    Created on : 4 Jan 2021, 10:51:41
    Author     : Jacob Dale
--%>
<%@page import="org.solent.com528.project.model.service.ServiceFacade"%>
<%@page import="org.solent.com528.project.model.dao.PriceCalculatorDAO"%>
<%@page import="org.solent.com528.project.impl.webclient.WebClientObjectFactory"%>
<%@page import="org.solent.com528.project.model.dto.PricingDetails"%>
<%@page import="java.util.List"%>
<%@page import="org.solent.com528.project.model.dto.PriceBand"%>
<%@page import="org.solent.com528.project.model.dto.Rate"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    String errorMessage = "";
    String message = "";
    ServiceFacade cleintServiceFacade = (ServiceFacade) WebClientObjectFactory.getServiceFacade();
    PriceCalculatorDAO priceCalcDAO = cleintServiceFacade.getPriceCalculatorDAO();
    PricingDetails pd = priceCalcDAO.getPricingDetails();
    List<PriceBand> pbList = pd.getPriceBandList();
    
    String actionStr = request.getParameter("action");
    if(actionStr == null || actionStr.isEmpty())
    {
        actionStr = "";
    }
    
    String newPeakTimeHStr = request.getParameter("newPeakTimeH");
    if(newPeakTimeHStr == null || newPeakTimeHStr.isEmpty())
    {
        newPeakTimeHStr = "";
    }
    
    String newPeakTimeMStr = request.getParameter("newPeakTimeM");
    if(newPeakTimeMStr == null || newPeakTimeMStr.isEmpty())
    {
        newPeakTimeMStr = "0";
    }
    
    String newOffPeakTimeHStr = request.getParameter("newOffPeakTimeH");
    if(newOffPeakTimeHStr == null || newOffPeakTimeHStr.isEmpty())
    {
        newOffPeakTimeHStr = "";
    }
    
    String newOffPeakTimeMStr = request.getParameter("newOffPeakTimeM");
    if(newOffPeakTimeMStr == null || newOffPeakTimeMStr.isEmpty())
    {
        newOffPeakTimeMStr = "0";
    }
    
    int peakHour = -1;
    int peakMin = -1;
    int offPeakHour = -1;
    int offPeakMin = -1;
                
    if(actionStr.equals("add"))
    {
        try
        {
            if(!newPeakTimeHStr.isEmpty())
            {
                peakHour = Integer.parseInt(newPeakTimeHStr);
                peakMin = Integer.parseInt(newPeakTimeMStr);
            }
            if(!newOffPeakTimeHStr.isEmpty())
            {
                offPeakHour = Integer.parseInt(newOffPeakTimeHStr);
                offPeakMin = Integer.parseInt(newOffPeakTimeMStr);
            }
        }
        catch(Exception ex)
        {
            errorMessage = "Please ensure the times are valid or blank";
        }
        try
        {
            if(peakHour != -1 && peakHour >= 0 && peakHour <= 24 )
            {
                Rate peakRate = Rate.PEAK;
                PriceBand pb = new PriceBand();
                pb.setHour(peakHour);
                pb.setMinutes(peakMin);
                pb.setRate(peakRate);
                pbList.add(pb);
                pd.setPriceBandList(pbList);
                priceCalcDAO.savePricingDetails(pd);
                message = "peak schedule saved";
            }
            else
            {
                throw new Exception("couldn't delete schedule, check times are in 24 hour and valid");
            }
            if(offPeakHour != -1 && offPeakHour >= 0 && offPeakHour <= 24 )
            {
                Rate peakRate = Rate.OFFPEAK;
                PriceBand pb = new PriceBand();
                pb.setHour(offPeakHour);
                pb.setMinutes(offPeakMin);
                pb.setRate(peakRate);
                pbList.add(pb);
                pd.setPriceBandList(pbList);
                priceCalcDAO.savePricingDetails(pd);
                message = message + " off peak schedule saved";
            }
        }
    catch(Exception ex)
    {
        errorMessage = "error saving new schedule";
    }
}
    if(actionStr.equals("delete"))
    {
        try
        {
            if(!newPeakTimeHStr.isEmpty())
            {
                peakHour = Integer.parseInt(newPeakTimeHStr);
                peakMin = Integer.parseInt(newPeakTimeMStr);
            }
            if(!newOffPeakTimeHStr.isEmpty())
            {
                offPeakHour = Integer.parseInt(newOffPeakTimeHStr);
                offPeakMin = Integer.parseInt(newOffPeakTimeMStr);
            }
             else
            {
                throw new Exception("couldn't add schedule, check times are in 24 hour and valid");
            }
        }
        catch(Exception ex)
        {
            errorMessage = ex.getLocalizedMessage();
        }
        try
        {
             if(peakHour != -1 && peakHour >= 0 && peakHour <= 24 )
            {
                Rate peakRate = Rate.PEAK;
                PriceBand pb = new PriceBand();
                pb.setHour(peakHour);
                pb.setMinutes(peakMin);
                pb.setRate(peakRate);
                priceCalcDAO.deletePriceBand(pb);
                message = "peak schedule deleted";
            }
            else
            {
                throw new Exception("couldn't delete schedule, check times are in 24 hour and valid");
            }
            if(offPeakHour != -1 && offPeakHour >= 0 && offPeakHour <= 24 )
            {
                Rate offPeakRate = Rate.PEAK;
                PriceBand pb = new PriceBand();
                pb.setHour(offPeakHour);
                pb.setMinutes(offPeakMin);
                pb.setRate(offPeakRate);
                priceCalcDAO.deletePriceBand(pb);
                message = "peak schedule deleted";
            }
            else
            {
                throw new Exception("couldn't delete schedule, check times are in 24 hour and valid");
            }
        }
        catch(Exception ex)
        {
            errorMessage = ex.getLocalizedMessage();
        }
    }
    
    if(actionStr.equals("deleteAll"))
    {
        priceCalcDAO.deleteAll();
    }

%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Peak and off peak editor</title>
    </head>
    <body>
        <h1>Edit Peak and Off Peak Times</h1>
        <div style="color:red;"><%=errorMessage%></div>
        <div style="color:green;"><%=message%></div>
        <p style="color:red">Please use 24 hour format</p>
        <form action="./timeScheduler.jsp"  method="post">
            <button type="submit">Refresh Page</button>
        </form>
        <form action="./timeScheduler.jsp"  method="get">
            <table>
                <tr>
                    <td>Enter new peak pricing:</td>
                    <td>
                        Hour: <input type="text" name="newPeakTimeH" value="<%=newPeakTimeHStr%>">
                        Minute: <input type="text" name="newPeakTimeM" value="<%=newPeakTimeMStr%>">
                    </td>
                </tr>
                 <tr>
                    <td>Enter new off peak pricing:</td>
                    <td>
                        Hour: <input type="text" name="newOffPeakTimeH" value="<%=newOffPeakTimeHStr%>">
                        Minute: <input type="text" name="newOffPeakTimeM" value="<%=newOffPeakTimeMStr%>">
                    </td>
                </tr>
                <tr>
                <tr><td style='color:red'>leave text area blank if you don't want it to be changed</td></tr>
                <tr>
                    <td>
                        <button type="submit" name="action" value="add">Add Time(s)</button>
                        <button type="submit" name="action" value="delete">Remove Time(s)</button>
                        <button type="submit" name="action" value="deleteAll" style="color:red;">Remove All Time(s)</button>
                    </td>
                </tr>
                <% for(PriceBand tempPb : pbList)
                    { %>
                    <tr>
                        <td><textArea rows="1" cols="50" name="PriceBands" readonly="true"><%=tempPb.toString()%></textarea></td>
                    </tr>
                <%}%>
            </table>
        </form>
    </body>
</html>
