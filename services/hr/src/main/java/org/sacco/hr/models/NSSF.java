package org.sacco.hr.models;

import lombok.Data;

import java.time.LocalDate;

@Data
public class NSSF {
    private String nssfNumber;
    private Integer staffId;
    private LocalDate registrationDate;
}
