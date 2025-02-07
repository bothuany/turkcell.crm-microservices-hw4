package com.turkcell.notificationservice.controllers;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/notification")
public class NotificationController {
    @GetMapping
    public String get() {
        System.out.println("get called");
        return "Notification Service";
    }
}
