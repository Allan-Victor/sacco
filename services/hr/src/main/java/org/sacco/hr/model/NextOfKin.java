package org.sacco.hr.model;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class NextOfKin {
    private Integer nextOfKinId;
    private String fullName;
    private Integer staffId;
    private String relationship;
    private String phoneNumber;
    private String kinNin;
    private String physicalAddress;

}
