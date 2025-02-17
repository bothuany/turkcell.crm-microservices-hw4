package io.github.bothuany.events.order;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@AllArgsConstructor
@Getter
@Setter
public class OrderCreatedEvent {
    private int id;
    private LocalDateTime date;
}
