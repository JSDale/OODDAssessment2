/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.solent.com528.project.impl.dao.jpa;

import java.net.URL;

/**
 *
 * @author Jacob
 */
public class PriceDetailsStorageHandler {

    public URL getPriceDetailsStorageURL() {
        
        URL url = PriceDetailsStorageHandler.class.getResource("./project/");
        return url;
    }
    
}
