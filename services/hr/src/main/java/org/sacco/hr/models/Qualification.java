package org.sacco.hr.models;

import lombok.*;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Qualification {
    private String name;
    private String institution;
    private LocalDate dateAchieved;


}
