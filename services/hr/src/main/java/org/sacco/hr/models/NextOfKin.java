package org.sacco.hr.models;

import lombok.Data;

@Data
public class NextOfKin {
    private Integer nextOfKinId;
    private String fullName;
    private Integer staffId;
    private String relationship;
    private String phoneNumber;
    private String kinNin;
    private String physicalAddress;

}
