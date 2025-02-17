package io.github.bothuany.events.customer;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@AllArgsConstructor
@Getter
@Setter
public class CustomerCreatedEvent {
    private int id;
    private LocalDateTime date;
}
