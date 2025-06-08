package org.sacco.hr.services;

import org.springframework.stereotype.Service;

@Service
public class AlertService {
     public void sendAlert(String message) {
        // Simulating alert (In real case, send email or SMS notification)
         System.out.println("ALERT: " + message);
    }
}
