/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.solent.com528.project.model.dto;

import java.util.Date;
import java.util.UUID;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * THIS IS A VERY BASIC TICKET - YOU WILL NEED TO IMPROVE THIS
 *
 * @author cgallen
 */
@XmlRootElement
@XmlAccessorType(XmlAccessType.FIELD)
public class Ticket {

    private String startStation;

    private Double cost;

    private String encryptedHash;

    private Rate rate;

    private Date issueDate;
    
    private int numberOfZones;
    
    private String Id;
    
    public String getId()
    {
        return Id;
    }
    
    public void setId()
    {
        this.Id = CreateUUID();
    }
    
    public int getNumberOfZones()
    {
        return this.numberOfZones;
    }
    
    public void setNumberOfZones(int numberOfZones)
    {
        this.numberOfZones = numberOfZones;
    }

    public String getStartStation() {
        return startStation;
    }

    public void setStartStation(String startStation) {
        this.startStation = startStation;
    }

    public Double getCost() {
        return cost;
    }

    public void setCost(Double cost) {
        this.cost = cost;
    }

    public String getEncryptedHash() {
        return encryptedHash;
    }

    public void setEncryptedHash(String encryptedHash) {
        this.encryptedHash = encryptedHash;
    }

    public Rate getRate() {
        return rate;
    }

    public void setRate(Rate rate) {
        this.rate = rate;
    }

    public Date getIssueDate() {
        return issueDate;
    }

    public void setIssueDate(Date issueDate) {
        this.issueDate = issueDate;
    }
    
    private String CreateUUID()
    {
        UUID uuid = UUID.randomUUID();
        return uuid.toString();
    }

    @Override
    public String toString() {
        return "Ticket{" +"id=" + Id + ", NumberOfZonesTravelable=" + numberOfZones + ", startStation=" + startStation + ", cost=" + cost + ", encryptedHash=" + encryptedHash + ", rate=" + rate + ", issueDate=" + issueDate + '}';
    }



}
