/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.solent.com528.project.impl.web;

import java.io.File;
import java.net.URL;
import java.sql.Connection;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.UUID;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.solent.com528.project.impl.dao.jaxb.StationDAOJaxbImpl;
import org.solent.com528.project.impl.service.ServiceObjectFactoryJpaImpl;
import org.solent.com528.project.impl.service.rest.client.ClientObjectFactoryImpl;
import org.solent.com528.project.impl.service.rest.client.ConfigurationPoller;
import org.solent.com528.project.model.dao.StationDAO;
import org.solent.com528.project.model.dto.Station;
import org.solent.com528.project.model.service.ServiceFacade;
import org.solent.com528.project.model.service.ServiceObjectFactory;

/**
 * ServletContextListeneer executes code on web app startup and shutdown
 * https://www.deadcoderising.com/execute-code-on-webapp-startup-and-shutdown-using-servletcontextlistener/
 * https://blog.georgovassilis.com/2014/01/15/tomcat-spring-and-memory-leaks-when-undeploying-or-redeploying-an-web-application/ Tomcat, Spring and memory leaks
 * when undeploying or redeploying an web application
 *
 * @author gallenc
 */
@WebListener
public class WebObjectFactory implements ServletContextListener {

    final static Logger LOG = LogManager.getLogger(WebObjectFactory.class);

    final static String TMP_DIR = System.getProperty("java.io.tmpdir");

    private static ServiceFacade serviceFacade = null;

    private static ServiceObjectFactory serviceObjectFactory = null;
    
    private static ServiceObjectFactory clientObjectFactory = null;
    
    private static ConfigurationPoller configurationPoller = null;


    public static ServiceFacade getServiceFacade() {
        if (serviceFacade == null) {
            synchronized (WebObjectFactory.class) {
                if (serviceFacade == null) {
                    LOG.debug("web application starting");

                    // this is needed to allow Derby to work as in embedded server
                    String derbyHome = TMP_DIR + File.separator + "derby";
                    LOG.debug("setting derby.system.home=" + derbyHome);

                    System.setProperty("derby.system.home", derbyHome);

                    serviceObjectFactory = new ServiceObjectFactoryJpaImpl();
                    serviceFacade = serviceObjectFactory.getServiceFacade();

                    StationDAO stationDAO = serviceFacade.getStationDAO();
                    List<Station> stationList = loadDefaultStations();
                    stationDAO.saveAll(stationList);
                }
            }
        }
        return serviceFacade;
    }
    
    public static ServiceFacade getClientServiceFacade()
    {
        if (serviceFacade == null) {
            synchronized (WebObjectFactory.class) {
                if (serviceFacade == null) {

                    LOG.debug("client web application starting");
                    clientObjectFactory = new ClientObjectFactoryImpl();
                    serviceFacade = clientObjectFactory.getServiceFacade();

                    configurationPoller = new ConfigurationPoller(serviceFacade);
                    // initially random uuid - can be set
                    String ticketMachineUuid = UUID.randomUUID().toString();
                    configurationPoller.setTicketMachineUuid(ticketMachineUuid);
                    long initialDelay = 0;
                    long delay = 30; // every 30 seconds
                    LOG.debug("starting configuration poller initialDelay=" + initialDelay
                            + ", delay=" + delay
                            + ", ticketMachineUuid=" + ticketMachineUuid);
                    configurationPoller.init(initialDelay, delay);
                }
            }
        }
        return serviceFacade;
    }

    private static List<Station> loadDefaultStations() {
        LOG.debug("LOADING DEFAULT STATIONS");
        List<Station> defaultStationList = new ArrayList<Station>();
        try {
            // NOTE this should but does not load from a file saved in the model jar
            URL res = WebObjectFactory.class.getClassLoader().getResource("londonStations.xml");
            String fileName = res.getPath();
            LOG.debug("loading from london underground fileName:   " + fileName);
            StationDAOJaxbImpl stationDAOjaxb = new StationDAOJaxbImpl(fileName);
            defaultStationList = stationDAOjaxb.findAll();

        } catch (Exception ex) {
            LOG.error("cannot load default stations", ex);
        }

        return defaultStationList;
    }

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        LOG.debug("WEB OBJECT FACTORY context initialised");
        // nothing to do
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        LOG.debug("WEB OBJECT FACTORY shutting down context");
        if (serviceObjectFactory != null) {
            synchronized (WebObjectFactory.class) {
                LOG.debug("WEB OBJECT FACTORY shutting down serviceObjectFactory");
                serviceObjectFactory.shutDown();
                LOG.debug("WEB OBJECT FACTORY shutting down derby database");
                shutdownDerby();
                LOG.debug("WEB OBJECT FACTORY derby shutdown");
            }

        }
    }

    // code to shutdown derby 
    // based on https://github.com/nuzayats/derby-shutdown-listener
    private static void shutdownDerby() {
        Connection cn = null;
        try {
            cn = DriverManager.getConnection("jdbc:derby:;shutdown=true");
            LOG.debug("Derby shutdown failed (no exception occurred).");
        } catch (SQLException e) {
            if ("XJ015".equals(e.getSQLState())) {
                LOG.info("Derby shutdown succeeded. SQLState={0}, message={1}",
                        new Object[]{e.getSQLState(), e.getMessage()});
                // LOG.debug( "Derby shutdown exception", e);
            } else {
                LOG.info("Derby shutdown failed or may not yet loaded. message: {0}", e.getMessage());
                LOG.debug("Derby shutdown failed", e);
            }
        } finally {
            if (cn != null) {
                try {
                    cn.close();
                } catch (Exception e) {
                    LOG.warn("Database closing error", e);
                }
            }
        }
        // unregister any jdbc drivers
        LOG.info("Unregistering any JDBC drivers ");
        Enumeration<Driver> drivers = DriverManager.getDrivers();
        while (drivers.hasMoreElements()) {
            java.sql.Driver driver = drivers.nextElement();
            LOG.info("Unregistering JDBC driver " + driver);
            try {
                java.sql.DriverManager.deregisterDriver(driver);
            } catch (Throwable t) {
            }
        }
    }

}
