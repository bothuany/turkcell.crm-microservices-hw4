package io.github.bothuany.events.product;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@AllArgsConstructor
@Getter
@Setter
public class ProductCreatedEvent {
    private int id;
    private LocalDateTime date;
}
