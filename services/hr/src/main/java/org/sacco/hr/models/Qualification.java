package org.sacco.hr.models;

import lombok.*;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Builder
public class Qualification {
    private Integer qualification_id;
    private Integer staffId;
    private String name;
    private String institution;
    private LocalDate dateAchieved;


}
