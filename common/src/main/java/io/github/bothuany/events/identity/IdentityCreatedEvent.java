package io.github.bothuany.events.identity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@AllArgsConstructor
@Getter
@Setter
public class IdentityCreatedEvent {
    private int id;
    private LocalDateTime date;
}
