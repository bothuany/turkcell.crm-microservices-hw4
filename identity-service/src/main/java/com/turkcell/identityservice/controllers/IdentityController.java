package com.turkcell.identityservice.controllers;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/identity")
public class IdentityController {
    @GetMapping
    public String get() {
        System.out.println("get called");
        return "Identity Service";
    }
}
